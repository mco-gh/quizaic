import json
import pprint
import google.generativeai as palm
import random
import vertexai
from vertexai.preview.language_models import TextGenerationModel

class Generator:
    def __init__(self, root, project="quizrd-prod-382117", location="us-central1"):
        self.root = root
        self.topics = []
        vertexai.init(project=project, location=location)
        self.prompt = open(self.root + "/palm/prompt.txt").read()

    def __str__(self):
        return "Palm quiz generator for quizrd.io"

    def get_topics(self, num=None):
        return self.topics

    def get_topic_formats(self):
        return ["free-form"]

    def get_answer_formats(self):
        return ["freeform", "multiple-choice"]

    def predict_llm(self, model, temp, tokens, top_p, top_k, content, tuned_model=""):
      m = TextGenerationModel.from_pretrained(model)
      if tuned_model:
          m = model.get_tuned_model(tuned_model)
      response = m.predict(content, temperature=temp, max_output_tokens=tokens,
          top_k=top_k, top_p=top_p)
      return response.text

    def gen_quiz(self, topic, num_questions, num_answers, difficulty=3, temperature=.5):
        prompt = self.prompt.format(topic=topic,
            num_questions=num_questions,
            num_answers=num_answers,
            difficulty=difficulty)
        quiz = self.predict_llm("text-bison@001", temperature, 1024, 0.8, 40, prompt)
        print(quiz)
        # randomize responses
        json_quiz = json.loads(quiz)
        for i in json_quiz:
            random.shuffle(i["responses"])
        quiz = json.dumps(json_quiz, indent=4)
        return quiz
