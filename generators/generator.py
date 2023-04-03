
import jeopardy
#import bard
#import chatgpt

supported_types = 
    "jeopardy": jeopardy,
#   "bard": bard, 
#   "chatgpt": chatgpt
}

class Generator:
    def __init__(self, type):
        if type not in supported_types:
            raise Exception(f"Unsupported generator type {type}.")
        self.type = type
        self._generator = self.supported_types[type]()

    def __str__(self):
        print(f"running __str__() on generator object")
        #self._instance.__str__(self)
