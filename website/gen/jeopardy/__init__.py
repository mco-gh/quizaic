import pandas as pd
import json

class Generator:
    def __init__(self, root):
        self.root = root
        self.db = pd.read_json(self.root + "/jeopardy/pruned_jeopardy.json")
        self.db.category = self.db.category.str.title().str.strip()

    def __str__(self):
        return "Jeopardy quiz generator for quizrd.io"

    def get_topics(self, num=100):
        return sorted(self.db.category.value_counts()[:num].index.tolist())

    def get_topic_formats(self):
        return ["multiple-choice"]

    def get_answer_formats(self):
        return ["freeform"]

    def gen_quiz(self, topic, numQuestions, numAnswers=1, difficulty=3, temperature=None):
        if topic not in self.db.category.unique():
            raise Exception(f"unknown topic {topic}")
        filtered = self.db.loc[self.db["category"] == topic]
        if difficulty <= 2:
            round = "Jeopardy!"
        elif difficulty <= 4:
            round = "Double Jeopardy!"
        else:
            round = "Final Jeopardy!"
        filtered = filtered[self.db["round"] == round]
        filtered = filtered[["question", "answer"]]
        filtered = filtered.rename(columns={"answer": "correct"})
        filtered = filtered.sample(numQuestions)
        if numQuestions < len(filtered.index):
            filtered = filtered.sample(n=numQuestions)
        return filtered.to_json(orient="records")
