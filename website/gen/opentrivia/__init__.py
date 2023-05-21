import glob

class Generator:
    def __init__(self):
        self.topics = glob.glob("*", root_dir="opentrivia/categories")
        print(self.topics)

    def __str__(self):
        return "OpenTrivia quiz generator for quizrd.io"

    def gen_quiz(self):
        return "I'm a quiz made by the Open Trivia Generator."

    def get_topics(self):
        return self.topics
