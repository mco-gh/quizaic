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

import pandas as pd
import os
import random
import sys

sys.path.append("../../../../")  # Needed for the main method to work in this class
from pyquizaic.generators.quiz.basequizgen import BaseQuizgen, DIFFICULTY


class Quizgen(BaseQuizgen):
    def __init__(self, config=None):
        data_path = os.path.join(os.path.dirname(__file__), "pruned_jeopardy.json")
        self.db = pd.read_json(data_path)
        self.db.category = self.db.category.str.title().str.strip()

    def __str__(self):
        return "jeopardy quiz generator"

    def get_topics(self, num=100):
        return set(sorted(self.db.category.value_counts()[:num].index.tolist()))

    def get_topic_formats(self):
        return ["multiple-choice"]

    def get_answer_formats(self):
        return ["freeform"]

    def gen_quiz(
        self, topic, num_questions, num_answers=1, difficulty=DIFFICULTY, temperature=None
    ):
        if topic not in self.db.category.unique():
            raise Exception(f"unknown topic {topic}")
        filtered = self.db.loc[self.db["category"] == topic]
        round1 = "Jeopardy!"
        round2 = "Double Jeopardy!"
        round3 = "Final Jeopardy!"
        if difficulty == "easy":
            difficulty = random.choice((1, 2))
        elif difficulty == "medium":
            difficulty = "3"
        elif difficulty == "difficult":
            difficulty = random.choice((4, 5))

        value1 = f"${difficulty * 100}"
        value2 = f"${difficulty * 200}"
        filtered = filtered.loc[
            (filtered["round"] == round1) & (filtered["value"] == value1)
            | (filtered["round"] == round2) & (filtered["value"] == value2)
            | (filtered["round"] == round3) & (difficulty == 5)
        ]
        filtered = filtered[["question", "answer"]]
        filtered = filtered.rename(columns={"answer": "correct"})
        filtered = filtered.sample(num_questions)
        if num_questions < len(filtered.index):
            filtered = filtered.sample(n=num_questions)
        return filtered.to_dict(orient="records")


if __name__ == "__main__":
    gen = Quizgen()
    num_questions = 3
    quiz = gen.gen_quiz("Physics", num_questions)
    print(json.dumps(quiz, indent=4))
