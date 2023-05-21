import pandas as pd
import json

class Generator:
    def __init__(self, root):
        self.db = pd.read_json(root + "/jeopardy/jeopardy.json")
        self.db["category"] = self.db["category"].str.title()

    def __str__(self):
        return "Jeopardy quiz generator for quizrd.io"

    def get_topics(self, num=100):
        return self.db["category"].value_counts()[:num].index.tolist()

    def get_mode(self):
        return "free form"

    def gen_quiz(self, topic, numQuestions, numAnswers):
        filtered = self.db[self.db.category == topic]
        filtered = filtered[["question", "answer"]]
        filtered = filtered.rename(columns={"answer":"correct"})
        filtered = filtered.sample(numQuestions)
        filtered["responses"] = "[]"
        return filtered.to_json(orient="records")
