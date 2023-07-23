import json
import pprint
import google.generativeai as palm
import os
import random
import vertexai
from vertexai.preview.language_models import TextGenerationModel

class Quizgen:
    def __init__(self, project="quizrd-prod-382117", location="us-central1"):
        self.topics = set()
        vertexai.init(project=project, location=location)
        data_path = os.path.join(os.path.dirname(__file__), "prompt.txt")
        with open(data_path, encoding='utf-8') as fp:
            self.prompt = fp.read()

    def __str__(self):
        return "palm quiz generator"

    def get_topics(self, num=None):
        return self.topics

    def get_topic_formats(self):
        return ["free-form"]

    def get_answer_formats(self):
        return ["free-form", "multiple-choice"]

    def predict_llm(self, model, temp, tokens, top_p, top_k, content, tuned_model=""):
      m = TextGenerationModel.from_pretrained(model)
      if tuned_model:
          m = model.get_tuned_model(tuned_model)
      response = m.predict(content, temperature=temp, max_output_tokens=tokens,
          top_k=top_k, top_p=top_p)
      return response.text

    def gen_quiz(self, topic, num_questions, num_answers, difficulty=3, temperature=.5):
        if difficulty <= 2:
            difficulty_word = "easy"
        elif difficulty <= 4:
            difficulty_word = "medium"
        elif difficulty <= 5:
            difficulty_word = "difficult"

        prompt = self.prompt.format(topic=topic,
            num_questions=num_questions,
            num_answers=num_answers,
            difficulty=difficulty)
        quiz = self.predict_llm("text-bison@001", temperature, 1024, 0.8, 40, prompt)
        # randomize responses
        json_quiz = json.loads(quiz)
        for i in json_quiz:
            random.shuffle(i["responses"])
        quiz = json.dumps(json_quiz, indent=4)
        return quiz
