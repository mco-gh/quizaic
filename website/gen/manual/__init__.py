import pandas as pd
import json

class Generator:
    def __init__(self, root):
        self.root = root
        self.topics = []

    def __str__(self):
        return "Manual quiz generator for quizrd.io"

    def get_topics(self, num=100):
        return self.topics

    def get_topic_formats(self):
        return []

    def get_answer_formats(self):
        return ["freeform", "multiple-choice"]

    def gen_quiz(self, topic, numQuestions, numAnswers):
        return None
