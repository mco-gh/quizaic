import os

# TODO: Implement
class Quizgen:
    def __init__(self, project="quizrd-prod-382117", location="us-central1"):
        self.topics = set()

    def __str__(self):
        return "gpt quiz generator"

    def get_topics(self, num=None):
        return self.topics

    def get_topic_formats(self):
        return ["free-form"]

    def get_answer_formats(self):
        return ["free-form", "multiple-choice"]

    def gen_quiz(self, topic, num_questions, num_answers, difficulty=3, temperature=.5):
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
