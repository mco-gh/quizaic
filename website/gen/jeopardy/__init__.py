import pandas
import json

class Generator:
    def __init__(self, root):
        self.db = pandas.read_json(root + "/jeopardy/jeopardy.json")
        self.db["category"] = self.db["category"].str.title()
        self.topics = sorted(list(self.db["category"].unique()))

    def __str__(self):
        return "Jeopardy quiz generator for quizrd.io"

    def get_topics(self):
        return self.topics

    def get_mode(self):
        return "free form"

    def gen_quiz(self, topic, numQuestions, numAnswers):
        filtered = self.db[self.db.category == topic]
        filtered = filtered[["question", "answer"]]
        filtered = filtered.rename(columns={"answer":"correct"})
        filtered = filtered.sample(numQuestions)
        filtered["responses"] = "[]"
        return filtered.to_json(orient="records")
