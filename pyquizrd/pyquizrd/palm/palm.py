import os
import vertexai
from vertexai.preview.language_models import TextGenerationModel

class Quizgen:

    DEFAULT_PROJECT = "quizrd-prod-382117" # "quizrd-atamel"
    DEFAULT_LOCATION = "us-central1"
    DEFAULT_PROMPT_FILE = "prompt2.txt"

    # TODO - project, location should be settable from pyquizrd.py Quizgen
    def __init__(self, project=DEFAULT_PROJECT, location=DEFAULT_LOCATION, prompt_file=DEFAULT_PROMPT_FILE):
        self.topics = set()
        vertexai.init(project=project, location=location)
        data_path = os.path.join(os.path.dirname(__file__), prompt_file)
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

    def get_difficulty_word(self, difficulty):
        if difficulty < 1 or difficulty > 5:
            raise Exception("Difficulty cannot be less than 1 or more than 5")

        if difficulty <= 2:
            return "easy"
        elif difficulty <= 4:
            return "medium"
        elif difficulty <= 5:
            return "difficult"

    def gen_quiz(self, topic, num_questions, num_answers, difficulty=3, temperature=.5):
        prompt = self.prompt.format(topic=topic,
            num_questions=num_questions,
            num_answers=num_answers,
            difficulty=self.get_difficulty_word(difficulty))
        quiz = self.predict_llm("text-bison@001", temperature, 1024, 0.8, 40, prompt)
        return quiz
