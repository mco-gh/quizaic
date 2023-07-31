class Quizgen:
    def __init__(self, config=None):
        self.topics = set()

    def __str__(self):
        return "manual quiz generator"

    def get_topics(self, num=100):
        return self.topics

    def get_topic_formats(self):
        return ["freeform"]

    def get_answer_formats(self):
        return ["freeform", "multiple-choice"]

    def gen_quiz(self, topic=None, num_questions=None, num_answers=None, difficulty=3, temperature=.5):
        return "[]"

    def eval_quiz(self, quiz, topic, num_questions, num_answers, shortcircuit_validity=True):
        return True, f"Valid quiz"