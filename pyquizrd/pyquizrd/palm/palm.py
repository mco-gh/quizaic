import json
import os
import vertexai
from vertexai.preview.language_models import TextGenerationModel

class Quizgen:

    DEFAULT_PROJECT = "quizrd-prod-382117"
    DEFAULT_LOCATION = "us-central1"
    DEFAULT_PROMPT_GEN_FILE = "prompt_gen2.txt"
    DEFAULT_PROMPT_EVAL_FILE = "prompt_eval2.txt"

    def __init__(self, config=None):
        project = Quizgen.DEFAULT_PROJECT
        location = Quizgen.DEFAULT_LOCATION
        prompt_gen_file = Quizgen.DEFAULT_PROMPT_GEN_FILE
        prompt_eval_file = Quizgen.DEFAULT_PROMPT_EVAL_FILE

        if config:
            project = config.get("project", Quizgen.DEFAULT_PROJECT)
            location = config.get("location", Quizgen.DEFAULT_LOCATION)
            prompt_gen_file = config.get("prompt_gen_file", Quizgen.DEFAULT_PROMPT_GEN_FILE)
            prompt_eval_file = config.get("prompt_eval_file", Quizgen.DEFAULT_PROMPT_EVAL_FILE)

        vertexai.init(project=project, location=location)

        self.topics = set()

        file_path = os.path.join(os.path.dirname(__file__), "prompts/" + prompt_gen_file)
        with open(file_path, encoding='utf-8') as fp:
            self.prompt_gen = fp.read()

        file_path = os.path.join(os.path.dirname(__file__), "prompts/" + prompt_eval_file)
        with open(file_path, encoding='utf-8') as fp:
            self.prompt_eval = fp.read()

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
        prompt = self.prompt_gen.format(topic=topic,
            num_questions=num_questions,
            num_answers=num_answers,
            difficulty=self.get_difficulty_word(difficulty))
        quiz = self.predict_llm("text-bison@001", temperature, 1024, 0.8, 40, prompt)
        quiz = json.loads(quiz)
        return quiz

    # Load quiz from quiz.json, mainly for testing
    def load_quiz(self, quiz_file):
        file = open(os.path.join(os.path.dirname(__file__), "quizzes/" + quiz_file))
        quiz = json.load(file)
        #quiz = json.dumps(quiz, indent=4) # format nicely
        return quiz

    # Given a quiz, check if it's a valid quiz:
    def eval_quiz(self, quiz, topic, num_questions, num_answers):
        # 1. It has right number of questions
        actual_num_questions = len(quiz)
        if actual_num_questions != num_questions:
            return False, f"Number of questions - actual: {actual_num_questions}, expected: {num_questions}"

        for value in quiz:
            # 2. It has right number of answers per question
            actual_num_answers = len(value["responses"])
            if actual_num_answers != num_answers:
                return False, f"Number of responses in question '{value['question']}' - actual: {actual_num_answers}, expected: {num_answers}"
            # 3. The correct answer is in the answers list
            correct = value["correct"]
            responses = value["responses"]
            if not correct in responses:
                return False, f"The correct answer '{correct}' for question '{value['question']}' is not in responses list: {responses}"

        prompt_eval = self.prompt_eval.format(quiz=quiz, topic=topic)
        temperature = 0 # To get consistent results in evaluation
        eval = self.predict_llm("text-bison@001", temperature, 1024, 0.8, 40, prompt_eval)
        questions = json.loads(eval)

        for value in questions:
            # 4. The question is on the right topic
            if not value["validity"]["is_question_on_topic"]:
                return False, f"Question '{value['question']}' is not on topic: {topic}"
            # 5. The question has the right correct answer
            if not value["validity"]["is_correct_correct"]:
                return False, f"Question '{value['question']}' does not have a correct answer: {value.correct}"

        # TODO - 6. The question has the right wrong answers
        return True, f"Valid quiz: {eval}"

if __name__ == "__main__":
    topic = "American History"
    num_questions = 2
    num_answers = 3

    gen = Quizgen()

    # quiz = gen.gen_quiz(topic, num_questions, num_answers)
    quiz = gen.load_quiz("quiz_cyprus_valid.json")
    print(json.dumps(quiz, indent=4))

    valid, details = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(valid, details)