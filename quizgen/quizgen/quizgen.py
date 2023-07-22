import importlib
import quizgen
import glob
import os

class Quizgen:
    def __init__(self, type):
        self.generators = {
            "gpt":        None,
            "jeopardy":   None,
            "manual":     None,
            "opentrivia": None,
            "palm":       None
        }
        if type not in self.generators:
            raise Exception(f"Unsupported generator type {type}.")
        if not self.generators[type]:
            mod = importlib.import_module(".." + type + "." + type, package="quizgen.quizgen")
            self.generators[type] = mod
        self.type = type
        print(f"{self.generators[type]=}")
        self._gen = self.generators[type].Quizgen()

    def __str__(self):
        return self._gen.__str__()

    @staticmethod
    def get_gens(root="quizgen"):
        gens = {}
        for g in self.generators:
           gens[g] = {
               "topic_formats":  gen.Quizgen(g, root).get_topic_formats(),
               "answer_formats": gen.Quizgen(g, root).get_answer_formats(),
               "topics":         gen.Quizgen(g, root).get_topics()
           }
        return gens

    def get_mode(self):
        return self._gen.get_mode()
    
    def get_topics(self, num=100):
        return self._gen.get_topics(num)

    def get_topic_formats(self):
        return self._gen.get_topic_formats()

    def get_answer_formats(self):
        return self._gen.get_answer_formats()

    def gen_quiz(self, topic, num_questions, num_answers, difficulty, temperature):
        return self._gen.gen_quiz(topic, num_questions, num_answers, difficulty, temperature)
