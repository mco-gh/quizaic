import sys
sys.path.append("../../../") # Needed for the main method to work in this class
from pyquizrd.generators.basequizgen import BaseQuizgen

# TODO: Implement
class Quizgen(BaseQuizgen):
    def __init__(self, config=None):
        self.topics = set()

    def __str__(self):
        return "gpt quiz generator"

    def get_topics(self, num=None):
        return self.topics

    def get_topic_formats(self):
        return ["free-form"]

    def get_answer_formats(self):
        return ["free-form", "multiple-choice"]

    def gen_quiz(self, topic, num_questions, num_answers, difficulty=3, temperature=.5):
        return '''[
                    {
                      "question":  "gpt question",
                      "correct":   "gpt answer",
                      "responses": [ 
                                     "gpt answer 1",
                                     "gpt answer 2",
                                     "gpt answer 3",
                                     "gpt answer 4"
                                   ]
                    }
                  ]'''

    def eval_quiz(self, quiz, topic, num_questions, num_answers, shortcircuit_validity=True):
        return True, f"Valid quiz"

if __name__ == "__main__":
    gen = Quizgen()
    print(f'gen:{gen}')