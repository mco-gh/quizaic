import pandas as pd
import json

class Quizgen:
    def __init__(self):
        self.topics = set()

    def __str__(self):
        return "manual quiz generator"

    def get_topics(self, num=100):
        return self.topics

    def get_topic_formats(self):
        return ["freeform"]

    def get_answer_formats(self):
        return ["freeform", "multiple-choice"]

    def gen_quiz(self, topic, num_questions, num_answers, difficulty, temperature=None):
        return "[]"
