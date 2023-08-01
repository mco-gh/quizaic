import importlib

# TODO: Change to proper inheritance
class Quizgen:

    GENERATORS = {
        "gpt":        None,
        "jeopardy":   None,
        "manual":     None,
        "opentrivia": None,
        "palm":       None
    }

    def __init__(self, config=None):
        pass

    def __str__(self):
        return "Quizgen Object"

    def get_mode(self):
        return None

    def get_topics(self, num=100):
        return None

    def get_topic_formats(self):
        return None

    def get_answer_formats(self):
        return None

    def gen_quiz(self, topic=None, num_questions=None, num_answers=None, difficulty=3, temperature=.5):
        return None

    # Load quiz from a file, mainly for testing
    def load_quiz(self, quiz_file=None):
        return None

    # Check that the quiz is valid, mainly for testing
    def eval_quiz(self, quiz, topic=None, num_questions=None, num_answers=None, shortcircuit_validity=True):
        return None
