class Generator:
    def __init__(self):
        self.topics = "unlimited"

    def __str__(self):
        return "Palm quiz generator for quizrd.io"

    def get_topics(self):
        return self.topics

    def gen_quiz(self):
        return "I'm a quiz made by the Bard Generator."
