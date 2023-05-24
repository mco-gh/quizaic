import pandas as pd
import json

class Generator:
    def __init__(self, root):
        self.root = root
        self.db = pd.read_json(self.root + "/jeopardy/jeopardy.json")
        self.db["category"] = self.db["category"].str.title()

    def __str__(self):
        return "Jeopardy quiz generator for quizrd.io"

    def get_topics(self, num=100):
        return sorted(self.db["category"].value_counts()[:num].index.tolist())

    def get_topic_formats(self):
        return ["multiple-choice"]

    def get_answer_formats(self):
        return ["freeform"]

    def gen_quiz(self, topic, numQuestions, numAnswers):
        filtered = self.db[self.db.category == topic]
        filtered = filtered[["question", "answer"]]
        filtered = filtered.rename(columns={"answer":"correct"})
        filtered = filtered.sample(numQuestions)
        filtered["responses"] = "[]"
        return filtered.to_json(orient="records")
