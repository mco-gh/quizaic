import pandas

class Generator:
    def __init__(self):
        self.topics = ["foo", "bar", "baz"]
        self.db = pandas.load_csv("jeopardy.csv")
        pandas.head(self.db)

    def __str__(self):
        return "Jeopardy Generator"

    def get_topics(self):
        return topics

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
