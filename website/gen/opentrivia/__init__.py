import glob

# https://opentdb.com/

class Generator:
    def __init__(self, root):
        self.root = root
        topics = sorted(glob.glob("*", root_dir=root+"/opentrivia/categories"))
        self.topics = map(lambda x: x.title(), topics)

    def __str__(self):
        return "OpenTrivia quiz generator for quizrd.io"

    def get_topics(self, num=None):
        return self.topics

    def get_topic_formats(self):
        return ["multiple-choice"]

    def get_answer_formats(self):
        return ["multiple-choice", "true/false"]

    def gen_quiz(self, topic, numQuestions, numAnswers, difficulty=3, temperature=None):
        return '''[
                    {
                      "question":  "opentrivia question",
                      "correct":   "opentrivia answer",
                      "responses": [
                                     "opentrivia answer 1",
                                     "opentrivia answer 2",
                                     "opentrivia answer 3",
                                     "opentrivia answer 4"
                                   ]
                    }
                  ]'''
