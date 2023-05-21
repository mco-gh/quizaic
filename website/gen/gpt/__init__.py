class Generator:
    def __init__(self, root):
        self.root = root
        self.topics = []

    def __str__(self):
        return "GPT quiz generator for quizrd.io"

    def get_topics(self, num=None):
        return self.topics

    def gen_quiz(self):
        return "I'm a quiz made by the ChatGPT Generator."
