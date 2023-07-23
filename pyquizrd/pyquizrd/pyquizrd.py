import importlib
import pyquizrd
import glob
import os

GENERATORS = {
    "gpt":        None,
    "jeopardy":   None,
    "manual":     None,
    "opentrivia": None,
    "palm":       None
}

class Quizgen:
    def __init__(self, type):
        if type not in GENERATORS:
            raise Exception(f"Unsupported generator type {type}.")
        if not GENERATORS[type]:
            mod = importlib.import_module(".." + type + "." + type, package="pyquizrd.pyquizrd")
            GENERATORS[type] = mod
        self.type = type
        self._gen = GENERATORS[type].Quizgen()

    def __str__(self):
        return self._gen.__str__()

    def get_gens():
        gens = {}
        for g in GENERATORS:
           gens[g] = {
               "topic_formats":  Quizgen(g).get_topic_formats(),
               "answer_formats": Quizgen(g).get_answer_formats(),
               "topics":         Quizgen(g).get_topics()
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
