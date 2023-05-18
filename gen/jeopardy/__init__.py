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

    def gen_quiz(self, numQuestions, numAnswers):
        questions = [
	]
        for i in numQuestions:
            for j in numAnswers:
                #questions.append()
                pass
        return "I'm a quiz made by the Jeopardy Generator."
