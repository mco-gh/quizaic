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

import sys

sys.path.append("../../../../")  # Needed for the main method to work in this class
from pyquizaic.generators.quiz.basequizgen import BaseQuizgen

import os
import openai

openai.api_key = os.getenv("OPENAI_API_KEY")


# TODO: Implement
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
        self, topic, num_questions, num_answers, difficulty=3, temperature=0.5
    ):
        completion = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {
                    "role": "system",
                    "content": "You are a poetic assistant, skilled in explaining complex programming concepts with creative flair.",
                },
                {
                    "role": "user",
                    "content": "Compose a poem that explains the concept of recursion in programming.",
                },
            ],
        )

        print(completion.choices[0].message)
        return """[
                    {
                      "question":  "gpt question",
                      "correct":   "gpt answer",
                      "responses": [ 
                                     "gpt answer 1",
                                     "gpt answer 2",
                                     "gpt answer 3",
                                     "gpt answer 4"
                                   ]
                    }
                  ]"""


if __name__ == "__main__":
    gen = Quizgen()
    print(f"gen:{gen}")
