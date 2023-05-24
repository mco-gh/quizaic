class Generator:
    def __init__(self, root):
        self.root = root
        self.topics = []

    def __str__(self):
        return "GPT quiz generator for quizrd.io"

    def get_topics(self, num=None):
        return self.topics

    def get_topic_formats(self):
        return ["freeform"]

    def get_answer_formats(self):
        return ["freeform", "multiple-choice"]

    def gen_quiz(self, topic, numQuestions, numAnswers):
        return '''[ 
                    {
                      "question":  "gpt question",
                      "correct":   "gpt answer",
                      "responses": [ 
                                     "gpt answer 1",
                                     "gpt answer 2",
                                     "gpt answer 3",
                                     "gpt answer 4"
                                   ]
                    }
                  ]'''
