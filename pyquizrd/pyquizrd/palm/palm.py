import json
import os
import vertexai
from vertexai.preview.language_models import TextGenerationModel

class Quizgen:

    DEFAULT_PROJECT = "quizrd-prod-382117"
    DEFAULT_LOCATION = "us-central1"
    DEFAULT_PROMPT_FILE = "prompts/prompt_generate2.txt"

    def __init__(self, config=None):
        project = Quizgen.DEFAULT_PROJECT
        location = Quizgen.DEFAULT_LOCATION
        prompt_file = Quizgen.DEFAULT_PROMPT_FILE

        if config:
            project = config.get("project", Quizgen.DEFAULT_PROJECT)
            location = config.get("location", Quizgen.DEFAULT_LOCATION)
            prompt_file = config.get("prompt_file", Quizgen.DEFAULT_PROMPT_FILE)

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
        quiz = json.loads(quiz)
        return quiz

    # Load quiz from quiz.json, mainly for testing
    def load_quiz(self):
        #file = open('quiz.json')
        file = open(os.path.join(os.path.dirname(__file__), "quiz.json"))
        quiz = json.load(file)
        #quiz = json.dumps(quiz, indent=4) # format nicely
        return quiz

    # Given a quiz, check if it's a valid quiz:
    # 1. It has right number of questions
    # 2. It has right number of answers per question
    # 3. The correct answer is in the answers list
    # 4. The question is on the right topic
    # 5. The question has the right correct answer
    # 6. The question has the right wrong answers
    def eval_quiz(self, quiz, topic, num_questions, num_answers):
        # 1. It has right number of questions
        actual_num_questions = len(quiz)
        if actual_num_questions != num_questions:
            return False, f"Number of questions - actual: {actual_num_questions}, expected: {num_questions}"

        for question in quiz:
            # 2. It has right number of answers per question
            actual_num_answers = len(question["responses"])
            if actual_num_answers != num_answers:
                return False, f"Number of responses in question '{question}' - actual: {actual_num_answers}, expected: {num_answers}"
            # 3. The correct answer is in the answers list
            correct = question["correct"]
            responses = question["responses"]
            if not correct in responses:
                return False, f"The correct answer '{correct}' for question '{question} is not in responses list: {responses}"

        # TODO: Implement #4, #5, #6 
        return True, "Valid quiz"

if __name__ == "__main__":
    topic = "Cyprus"
    num_questions = 2
    num_answers = 3

    # config = {"project": "quizrd-atamel"}
    # gen = Quizgen(config)
    # quiz = gen.gen_quiz(topic, num_questions, num_answers)
    # print(json.dumps(quiz, indent=4))

    gen = Quizgen()
    quiz = gen.load_quiz()
    print(json.dumps(quiz, indent=4))

    valid, details = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(valid, details)