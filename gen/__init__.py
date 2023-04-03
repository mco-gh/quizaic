
import gen.jeopardy
import gen.bard
import gen.chatgpt

supported_types = {
    "jeopardy": Jeopardy_gen,
    "bard": Bard_gen, 
    "chatgpt": Chatgpt_gen
}

class Generator:
    def __init__(self, type):
        if type not in supported_types:
            raise Exception(f"Unsupported generator type {type}.")
        self.type = type
        self._gen = self.supported_types[type]()

    def __str__(self):
        print(f"running __str__() on generator object")
        #self._gen.__str__(self)

    def gen_quiz(self):
        pass
