import glob

class Generator:
    def __init__(self, root):
        topics = sorted(glob.glob("*", root_dir=root+"/opentrivia/categories"))
        self.topics = map(lambda x: x.title(), topics)

    def __str__(self):
        return "OpenTrivia quiz generator for quizrd.io"

    def gen_quiz(self):
        return "I'm a quiz made by the Open Trivia Generator."

    def get_topics(self, num=None):
        return self.topics
