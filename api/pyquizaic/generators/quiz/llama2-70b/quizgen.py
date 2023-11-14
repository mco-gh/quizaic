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
from google.cloud import aiplatform

import sys

sys.path.append("../../../../")  # Needed for the main method to work in this class
from pyquizaic.generators.quiz.basequizgen import BaseQuizgen


class Quizgen(BaseQuizgen):
    def __init__(self, config=None):
        self.topics = set()

    def __str__(self):
        return "Llama2-70b quiz generator"

    def get_topics(self, num=None):
        return self.topics

    def get_topic_formats(self):
        return ["free-form"]

    def get_answer_formats(self):
        return ["free-form", "multiple-choice"]

    def predict_custom_trained_model(
        self,
        prompt,
        project="780573810218",
        endpoint_id="5234222905004392448",
        location = "us-central1",
        api_endpoint = "us-central1-aiplatform.googleapis.com",
        parameters = {},
    ):
        client_options = {"api_endpoint": api_endpoint}
        client = aiplatform.gapic.PredictionServiceClient(client_options=client_options)
        instances = [
            {
                "prompt": prompt,
                "max_tokens": 1024
            }
        ]
        endpoint = client.endpoint_path(
            project=project, location=location, endpoint=endpoint_id
        )
        response = client.predict(
            endpoint=endpoint, instances=instances, parameters=parameters
        )
        predictions = response.predictions
        return predictions[0]


    def gen_quiz(
        self,
        topic=BaseQuizgen.TOPIC,
        num_questions=BaseQuizgen.NUM_QUESTIONS,
        num_answers=BaseQuizgen.NUM_ANSWERS,
        difficulty=BaseQuizgen.DIFFICULTY,
        language=BaseQuizgen.LANGUAGE,
        temperature=BaseQuizgen.TEMPERATURE,
    ):
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
        s = self.predict_custom_trained_model(prompt)
        depth = 0
        prediction = ""
        for i in s:
            if i == "[":
                prediction += i
                depth += 1
            elif prediction and i == "]":
                prediction += i
                depth -= 1
                if depth == 0:
                    break
            elif prediction:
                prediction += i

        quiz = json.loads(prediction)
        # Make sure the correct answer appears randomly in responses
        for i in quiz:
            random.shuffle(i["responses"])
        return quiz


if __name__ == "__main__":
    gen = Quizgen()
    quiz = gen.gen_quiz(topic="science", num_questions=3, num_answers=4)
    print(json.dumps(quiz, indent=4))
