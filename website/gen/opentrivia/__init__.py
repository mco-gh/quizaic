import glob

class Generator:
    def __init__(self, root):
        self.topics = glob.glob("*", root_dir=root)
        print(self.topics)

    def __str__(self):
        return "OpenTrivia quiz generator for quizrd.io"

    def gen_quiz(self):
        return "I'm a quiz made by the Open Trivia Generator."

    def get_topics(self):
        return self.topics
