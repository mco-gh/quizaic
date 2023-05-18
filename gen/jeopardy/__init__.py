import pandas

class Generator:
    def __init__(self):
        self.db = pandas.read_json("gen/jeopardy/jeopardy.json")
        self.topics = self.db["category"]

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
        return filtered.to_json(orient="records")