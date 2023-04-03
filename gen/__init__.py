import importlib
import gen

supported_gens = {
    "jeopardy": None,
    "bard":     None, 
    "chatgpt":  None,
}

for i in supported_gens:
    supported_gens[i] = importlib.import_module("gen." + i)

class Generator:
    def __init__(self, type):
        if type not in supported_gens:
            raise Exception(f"Unsupported generator type {type}.")
        self.type = type
        self._gen = supported_gens[type].Generator()

    def __str__(self):
        return self._gen.__str__()

    def gen_quiz(self):
        return self._gen.gen_quiz()
