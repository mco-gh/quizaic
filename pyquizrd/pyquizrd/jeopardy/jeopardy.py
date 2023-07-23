import pandas as pd
import json
import os

class Quizgen:
    def __init__(self):
        data_path = os.path.join(os.path.dirname(__file__), "pruned_jeopardy.json")
        self.db = pd.read_json(data_path)
        self.db.category = self.db.category.str.title().str.strip()

    def __str__(self):
        return "jeopardy quiz generator"

    def get_topics(self, num=100):
        return sorted(self.db.category.value_counts()[:num].index.tolist())

    def get_topic_formats(self):
        return ["multiple-choice"]

    def get_answer_formats(self):
        return ["freeform"]

    def gen_quiz(self, topic, num_questions, num_answers=1, difficulty=3, temperature=None):
        if topic not in self.db.category.unique():
            raise Exception(f"unknown topic {topic}")
        filtered = self.db.loc[self.db["category"] == topic]
        round1 = "Jeopardy!"
        round2 = "Double Jeopardy!"
        round3 = "Final Jeopardy!"
        value1 = f"${difficulty * 100}"
        value2 = f"${difficulty * 200}"
        filtered = filtered.loc[
            (filtered["round"] == round1) & (filtered["value"] == value1) |
            (filtered["round"] == round2) & (filtered["value"] == value2) |
            (filtered["round"] == round3) & (difficulty == 5)
        ]
        filtered = filtered[["question", "answer"]]
        filtered = filtered.rename(columns={"answer": "correct"})
        filtered = filtered.sample(num_questions)
        if num_questions < len(filtered.index):
            filtered = filtered.sample(n=num_questions)
        return filtered.to_json(orient="records", indent=4)
