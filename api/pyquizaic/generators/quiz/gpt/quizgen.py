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

import json
import sys

sys.path.append("../../../../")  # Needed for the main method to work in this class
from pyquizaic.generators.quiz.basequizgen import BaseQuizgen

import os
import openai

openai.api_key = os.getenv("OPENAI_API_KEY")

file_path = os.path.join(os.path.dirname(__file__), f"../prompt.txt")
with open(file_path, encoding="utf-8") as f:
    prompt = f.read()

class Quizgen(BaseQuizgen):
    def __init__(self, config=None):
        self.topics = set()

    def __str__(self):
        return "gpt quiz generator"

    def get_topics(self, num=None):
        return self.topics

    def get_topic_formats(self):
        return ["free-form"]

    def get_answer_formats(self):
        return ["free-form", "multiple-choice"]

    def gen_quiz(
        self, topic, num_questions, num_answers=4, difficulty=3, language="English", temperature=0.5
    ):
        prompt2 = prompt.format(topic=topic, num_questions=num_questions,
            num_answers=num_answers, difficulty=difficulty, language=language,
            temperature=temperature)
        completion = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {
                    "role": "assistant",
                    "content": prompt2,
                },
            ],
        )
        return completion.choices[0].message.content


if __name__ == "__main__":
    gen = Quizgen()
    print(json.loads(quiz, indent=4))
