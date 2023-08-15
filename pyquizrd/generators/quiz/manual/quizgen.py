import sys
sys.path.append("../../../../") # Needed for the main method to work in this class
from pyquizrd.generators.quiz.basequizgen import BaseQuizgen

class Quizgen(BaseQuizgen):

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


if __name__ == "__main__":
    gen = Quizgen()
    print(f'gen:{gen}')
