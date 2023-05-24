class Generator:
    def __init__(self, root):
        self.root = root
        self.topics = []

    def __str__(self):
        return "Palm quiz generator for quizrd.io"

    def get_topics(self, num=None):
        return self.topics

    def get_topic_formats(self):
        return ["free-form"]

    def get_answer_formats(self):
        return ["freeform", "multiple-choice"]

    def gen_quiz(self, topic, numQuestions, numAnswers):
        return '''[   
                    { 
                      "question":  "palm question",
                      "correct":   "palm answer",
                      "responses": [   
                                     "palm answer 1",
                                     "palm answer 2",
                                     "palm answer 3",
                                     "palm answer 4"
                                   ]
                    }
                  ]'''
