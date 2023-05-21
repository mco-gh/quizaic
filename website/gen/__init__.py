import importlib
import gen
import os

generators = {
    "jeopardy":   None,
    "palm":       None, 
    "gpt":        None,
    "opentrivia": None,
}

class Generator:
    def __init__(self, type, root="gen"):
        if type not in generators:
            raise Exception(f"Unsupported generator type {type}.")
        if not generators[type]:
            generators[type] = importlib.import_module("gen." + type)
        self.type = type
        self._gen = generators[type].Generator(root)

    def __str__(self):
        return self._gen.__str__()

    @staticmethod
    def get_gens(root="gen"):
        gens = {}
        for g in generators:
            gens[g] = gen.Generator(g, root).get_topics()
        return gens

    def get_topics(self):
        return self._gen.get_topics()

    def get_mode(self):
        return self._gen.get_mode()

    def gen_quiz(self, topic, numQuestions, numAnswers):
        return self._gen.gen_quiz(topic, numQuestions, numAnswers)
