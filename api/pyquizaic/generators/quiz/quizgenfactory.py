import importlib
import sys

sys.path.append("../../")  # Needed for the main method to work in this class


class QuizgenFactory:
    GENERATORS = {
        "gpt": None,
        "jeopardy": None,
        "manual": None,
        "opentrivia": None,
        "palm": None,
    }

    @staticmethod
    def get_gen(type, config=None):
        if type not in QuizgenFactory.GENERATORS:
            raise Exception(f"Unsupported generator type {type}.")
        if not QuizgenFactory.GENERATORS[type]:
            mod = importlib.import_module(f"pyquizaic.generators.quiz.{type}.quizgen")
            QuizgenFactory.GENERATORS[type] = mod
        return QuizgenFactory.GENERATORS[type].Quizgen(config)

    @staticmethod
    def get_gens():
        gens = {}
        for type in QuizgenFactory.GENERATORS:
            gens[type] = {
                "topic_formats": QuizgenFactory.get_gen(type).get_topic_formats(),
                "answer_formats": QuizgenFactory.get_gen(type).get_answer_formats(),
                "topics": QuizgenFactory.get_gen(type).get_topics(),
            }
        return gens


if __name__ == "__main__":
    gen = QuizgenFactory.get_gen("gpt")
    print(f"gen:{gen}")

    gen = QuizgenFactory.get_gen("jeopardy")
    print(f"gen:{gen}")

    gen = QuizgenFactory.get_gen("manual")
    print(f"gen:{gen}")

    gen = QuizgenFactory.get_gen("opentrivia")
    print(f"gen:{gen}")

    gen = QuizgenFactory.get_gen("palm")
    print(f"gen:{gen}")

    gens = QuizgenFactory.get_gens()
    print(f"gens:{gens}")
