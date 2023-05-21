import importlib
import gen

generators = {
    "jeopardy":   None,
    "palm":       None, 
    "gpt":        None,
    "opentrivia": None,
}

class Generator:
    def __init__(self, type):
        if type not in generators:
            raise Exception(f"Unsupported generator type {type}.")
        if not generators[type]:
            generators[type] = importlib.import_module("gen." + type)
        self.type = type
        self._gen = generators[type].Generator()

    def __str__(self):
        return self._gen.__str__()

    @staticmethod
    def get_gens():
        gens = {}
        for g in generators:
            gens[g] = gen.Generator(g).get_topics()
        return gens

    def get_topics(self):
        return self._gen.get_topics()

    def get_mode(self):
        return self._gen.get_mode()

    def gen_quiz(self, topic, numQuestions, numAnswers):
        return self._gen.gen_quiz(topic, numQuestions, numAnswers)
