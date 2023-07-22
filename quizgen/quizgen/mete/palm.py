import json
import vertexai
from vertexai.preview.language_models import TextGenerationModel

class Generator:
    def __init__(self, project, location):
        vertexai.init(project=project, location=location)

    def predict_llm(self, model, temp, tokens, top_p, top_k, content, tuned_model=""):
      m = TextGenerationModel.from_pretrained(model)
      if tuned_model:
          m = model.get_tuned_model(tuned_model)
      response = m.predict(content, temperature=temp, max_output_tokens=tokens,
          top_k=top_k, top_p=top_p)
      return response.text

    def gen_quiz(self, prompt_file, topic, num_questions, num_answers, difficulty=3, temperature=.5):
        if difficulty <= 2:
            difficulty_word = "easy"
        elif difficulty <= 4:
            difficulty_word = "medium"
        elif difficulty <= 5:
            difficulty_word = "difficult"

        prompt = open(prompt_file).read()
        prompt = prompt.format(topic=topic,
            num_questions=num_questions,
            num_answers=num_answers,
            difficulty=difficulty)

        quiz = self.predict_llm("text-bison@001", temperature, 1024, 0.8, 40, prompt)
        return quiz

    def eval_quiz(self, prompt_file, quiz):
        prompt = open(prompt_file).read()
        prompt = prompt.format(quiz=quiz)

        quiz = self.predict_llm("text-bison@001", 0, 1024, 0.8, 40, prompt)
        return quiz

if __name__ == "__main__":
    generator = Generator(project="quizrd-atamel", location="us-central1");

    # Generate quiz with Palm
    # quiz = generator.gen_quiz(prompt_file="prompts/generate_prompt.txt", topic="Cyprus History", num_questions=2, num_answers=4, difficulty=5, temperature=1)

    # Testing: Read from quiz.json
    file = open('quiz.json')
    quiz = json.load(file)
    quiz = json.dumps(quiz, indent=4) # format nicely

    print(f'Quiz: \n{quiz}')

    # Evaluate quiz
    eval = generator.eval_quiz(prompt_file="prompts/evaluate_prompt.txt", quiz=quiz)
    print(f'Eval: \n{eval}')
