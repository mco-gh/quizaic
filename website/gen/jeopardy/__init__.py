import pandas
import json

class Generator:
    def __init__(self):
        self.db = pandas.read_json("gen/jeopardy/jeopardy.json")
        self.db["category"] = self.db["category"].str.title()
        #foo = json.dumps(json.loads(self.db.to_json(orient="records")), indent=4)
        #text_file = open("gen/jeopardy/jeopardy2.json", "w")
        #text_file.write(foo)
        self.topics = sorted(list(self.db["category"].unique()))

    def __str__(self):
        return "Jeopardy Quiz Generator for quizrd.io"

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
