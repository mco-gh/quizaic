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


class Quizgen(BaseQuizgen):
    def __init__(self, config=None):
        self.topics = set()

    def __str__(self):
        return "manual quiz generator"

    def get_topics(self, num=100):
        return self.topics

    def get_topic_formats(self):
        return ["freeform"]

    def get_answer_formats(self):
        return ["freeform", "multiple-choice"]

    def gen_quiz(
        self,
        topic=BaseQuizgen.TOPIC,
        num_questions=BaseQuizgen.NUM_QUESTIONS,
        num_answers=BaseQuizgen.NUM_ANSWERS,
        difficulty=BaseQuizgen.DIFFICULTY,
        language=BaseQuizgen.LANGUAGE,
        temperature=BaseQuizgen.TEMPERATURE,
    ):
        return "[]"


if __name__ == "__main__":
    gen = Quizgen()
    print(f"gen:{gen}")
