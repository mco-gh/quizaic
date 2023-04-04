import importlib
import gen

supported_gens = {
    "jeopardy":   None,
    "bard":       None, 
    "chatgpt":    None,
    "opentrivia": None,
}

class Generator:
    def __init__(self, type):
        if type not in supported_gens:
            raise Exception(f"Unsupported generator type {type}.")
        if not supported_gens[type]:
            supported_gens[type] = importlib.import_module("gen." + type)
        self.type = type
        self._gen = supported_gens[type].Generator()

    def gens():
        return set(supported_gens.keys())

    def modes(self):
        return None

    def topics(self):
        return None

    def __str__(self):
        return self._gen.__str__()

    def gen_quiz(self):
        return self._gen.gen_quiz()
