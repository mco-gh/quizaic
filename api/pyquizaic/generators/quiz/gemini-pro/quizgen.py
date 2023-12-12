# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import copy
import json
import os
import random
import re
import sys
import vertexai
from vertexai.preview.generative_models import (
    GenerationConfig,
    GenerativeModel,
    Image,
    Part,
)

sys.path.append("../../../../")  # Needed for the main method to work in this class
from pyquizaic.generators.quiz.basequizgen import BaseQuizgen

#PROJECT_ID = "quizaic"
PROJECT_ID = "cloud-llm-preview1"
REGION = "us-central1"
MODEL = "gemini-pro"
MAX_OUTPUT_TOKENS = 1024
TOP_P = 0.8
TOP_K = 40


class Quizgen(BaseQuizgen):
    def __init__(self, config=None):
        vertexai.init(project=PROJECT_ID, location=REGION)
        self.topics = set()

    def __str__(self):
        return "gemini-pro quiz generator"

    def get_topics(self, num=None):
        return self.topics

    def get_topic_formats(self):
        return ["free-form"]

    def get_answer_formats(self):
        return ["free-form", "multiple-choice"]

    @staticmethod
    def predict_llm(
        model_name, prompt, temperature, max_output_tokens, top_p, top_k, tuned_model=""
    ):
        model = GenerativeModel(model_name)
        responses = model.generate_content(
            prompt, stream=True, generation_config = {
                "temperature": temperature,
                "top_k": top_k,
                "top_p": top_p,
            }
        )
        result = ""
        for response in responses:
            #print(f"{response=}")
            result += response.text
        return result

    # Load quiz from a quiz_<topic>.json file, mainly for testing
    @staticmethod
    def load_quiz(quiz_file):
        file = open(os.path.join(os.path.dirname(__file__), "quizzes/" + quiz_file))
        quiz = json.load(file)

        topic = re.search(r"_(.*)\.json", quiz_file).group(1)
        num_questions = len(quiz)
        num_answers = len(quiz[0]["responses"])

        return quiz, topic, num_questions, num_answers

    def gen_quiz(
        self,
        topic=BaseQuizgen.TOPIC,
        num_questions=BaseQuizgen.NUM_QUESTIONS,
        num_answers=BaseQuizgen.NUM_ANSWERS,
        difficulty=BaseQuizgen.DIFFICULTY,
        language=BaseQuizgen.LANGUAGE,
        temperature=BaseQuizgen.TEMPERATURE,
    ):
        # print(f"{topic=}, {num_questions=}, {num_answers=}, {difficulty=}, {language=}")
        file_path = os.path.join(os.path.dirname(__file__), f"../prompt.txt")
        with open(file_path, encoding="utf-8") as fp:
            self.prompt_template = fp.read()

        prompt = self.prompt_template.format(
            topic=topic,
            num_questions=num_questions,
            num_answers=num_answers,
            language=language,
            difficulty=difficulty,
        )
        prediction = self.predict_llm(
            MODEL, prompt, temperature, MAX_OUTPUT_TOKENS, TOP_P, TOP_K
        )
        #print(f"{type(prediction)=}, {prediction=}")
        prediction = prediction.strip()
        if prediction[0:7].lower() == "```json":
            prediction = prediction[7:]
        elif prediction[0:8].lower() == "``` json":
            prediction = prediction[8:]
        if prediction[-3:].lower() == "```":
            prediction = prediction[:-3]
        quiz = json.loads(prediction)
        #print(f"{quiz=}")
        # Make sure the correct answer appears randomly in responses
        for i in quiz:
            random.shuffle(i["responses"])
        return quiz


if __name__ == "__main__":
    gen = Quizgen()
    quiz = gen.gen_quiz(topic="science", num_questions=3, num_answers=4)
    print(json.dumps(quiz, indent=4))
