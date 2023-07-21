import json
import pprint
import google.generativeai as palm
import random
import vertexai
from vertexai.preview.language_models import TextGenerationModel

class Generator:
    def __init__(self, project, location, prompt_file):
        vertexai.init(project=project, location=location)
        self.prompt = open(prompt_file).read()

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
        return quiz

if __name__ == "__main__":
    g = Generator(project="quizrd-atamel", location="us-central1", prompt_file="prompts/generate_prompt.txt");
    q = g.gen_quiz(topic="Cyprus History", num_questions=1, num_answers=4, difficulty=5, temperature=1)
    print(q)
