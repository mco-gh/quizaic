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
from vertexai.preview.language_models import TextGenerationModel

import sys

sys.path.append("../../../../")  # Needed for the main method to work in this class
from pyquizaic.generators.quiz.basequizgen import BaseQuizgen

MODEL = "text-bison"
PROMPT_FILE = "gen_4.txt"
MAX_OUTPUT_TOKENS = 1024
TOP_P = 0.8
TOP_K = 40

class Quizgen(BaseQuizgen):
    def __init__(self, config=None):
        # This doesn't seem to be needed
        # vertexai.init(project=project_id, location=region)

        self.topics = set()

        file_path = os.path.join(os.path.dirname(__file__), "prompts/" + PROMPT_FILE)
        with open(file_path, encoding="utf-8") as fp:
            self.prompt_template = fp.read()

    def __str__(self):
        return "palm quiz generator"

    def get_topics(self, num=None):
        return self.topics

    def get_topic_formats(self):
        return ["free-form"]

    def get_answer_formats(self):
        return ["free-form", "multiple-choice"]

    @staticmethod
    def predict_llm(
        model, prompt, temperature, max_output_tokens, top_p, top_k, tuned_model=""
    ):
        model = TextGenerationModel.from_pretrained(model)
        if tuned_model:
            model = model.get_tuned_model(tuned_model)
        response = model.predict(
            prompt,
            temperature=temperature,
            max_output_tokens=max_output_tokens,
            top_k=top_k,
            top_p=top_p,
        )
        return response.text

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
        self, topic, num_questions, num_answers,
        difficulty=BaseQuizgen.DIFFICULTY,
        language=BaseQuizgen.LANGUAGE,
        temperature=BaseQuizgen.TEMPERATURE
    ):
        #if difficulty == "medium":
            #difficulty += " difficulty"

        print(f"{topic=}, {num_questions=}, {num_answers=}, {difficulty=}, {language=}")
        prompt = self.prompt_template.format(
            topic=topic,
            num_questions=num_questions,
            num_answers=num_answers,
            difficulty=difficulty,
            language=language
        )
        print(f"{prompt=}")
        prediction = self.predict_llm(MODEL, prompt, temperature, MAX_OUTPUT_TOKENS, TOP_P, TOP_K)
        prediction = prediction.strip()
        print(f'X{prediction[0:8].lower()}X, {prediction[0:8].lower() == "``` json"}')
        if prediction[0:7].lower() == "```json":
            print("removing prefix")
            prediction = prediction[7:]
        elif prediction[0:8].lower() == "``` json":
            print("removing prefix")
            prediction = prediction[8:]
        if prediction[-3:].lower() == "```":
            print("removing suffix")
            prediction = prediction[:-3]
        print(f"{prediction=}")
        quiz = json.loads(prediction)
        # Make sure the correct answer appears randomly in responses
        for i in quiz:
            random.shuffle(i["responses"])
        return quiz


if __name__ == "__main__":
    gen = Quizgen()
    # print(f'gen:{gen}')
    # exit(0)

    # prompt = "question: In the DC Comics 2016 reboot, Rebirth, which speedster escaped from the Speed Force after he had been erased from existance? Eobard Thawne?"
    # result = gen.predict_llm(MODEL, 0, MAX_OUTPUT_TOKENS, 0.8, 40, prompt)
    # print(f'result:{result == ""}')
    # exit()

    topic = "science"
    num_questions = 3
    num_answers = 4
    quiz = gen.gen_quiz("science", num_questions, num_answers)
    # quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_cyprus.json")
    print(json.dumps(quiz, indent=4))
