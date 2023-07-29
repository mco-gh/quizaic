import copy
import json
import os
import random
import re
import vertexai
from vertexai.preview.language_models import TextGenerationModel

class Quizgen:

    DEFAULT_PROJECT = "quizrd-prod-382117"
    DEFAULT_LOCATION = "us-central1"
    DEFAULT_PROMPT_GEN_FILE = "prompt_gen2.txt"
    DEFAULT_PROMPT_EVAL_FILE = "prompt_eval3.txt"

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
        # Make sure the correct answer appears randomly in responses
        for i in quiz:
            random.shuffle(i["responses"])
        return quiz

    # Load quiz from a quiz_<topic>.json file, mainly for testing
    def load_quiz(self, quiz_file):
        file = open(os.path.join(os.path.dirname(__file__), "quizzes/" + quiz_file))
        quiz = json.load(file)
        #print(json.dumps(quiz, indent=4))

        topic = re.search(r"_(.*)\.json", quiz_file).group(1)
        num_questions = len(quiz)
        num_answers = len(quiz[0]["responses"])

        return quiz, topic, num_questions, num_answers

    # Given a quiz, check if it's a valid quiz
    def eval_quiz(self, quiz, topic, num_questions, num_answers) -> tuple[bool, str]:
        # 1. It has right number of questions
        actual_num_questions = len(quiz)
        if actual_num_questions != num_questions:
            return False, f"Invalid #1: Number of questions - actual: {actual_num_questions}, expected: {num_questions}"

        for item in quiz:
            # 2. It has right number of answers per question
            responses = item["responses"]
            actual_num_answers = len(responses)
            if actual_num_answers != num_answers:
                return False, f"Invalid #2: Number of responses in question '{item['question']}' - actual: {actual_num_answers}, expected: {num_answers}"
            # 3. The correct answer is in the answers list
            correct = item["correct"]
            if not correct in responses:
                return False, f"Invalid #3: The correct answer '{correct}' for question '{item['question']}' is not in responses list: {responses}"

        # Remove correct answer from each question to not bias the LLM during eval
        quiz_eval = copy.deepcopy(quiz)
        for item in quiz_eval:
            item.pop("correct")

        prompt_eval = self.prompt_eval.format(quiz=json.dumps(quiz_eval, indent=4), topic=topic)
        #print(f'prompt_eval: {prompt_eval}')
        temp = 0 # To get consistent results in evaluation
        eval = self.predict_llm("text-bison@001", temp, 1024, 0.8, 40, prompt_eval)
        #print(f'eval1: {eval}')
        eval = json.loads(eval)
        #print(f'eval2: {eval}')

        # [{"on_topic": true, "correct": ["George Washington"], "incorrect": ["Benjamin Franklin", "Thomas Jefferson"]},
        for index, item in enumerate(eval):
            # 4. The question is on the right topic
            if not item["on_topic"]:
                return False, f"Invalid #4: {eval}"
            # 5. The correct answer is indeed correct
            if item["correct"] != quiz[index]["correct"]:
                return False, f"Invalid #5: {eval}"
            # 6. The rest of responses are incorrect
            responses = quiz_eval[index]["responses"]
            responses.remove(item["correct"])
            for incorrect in item["incorrect"]:
                responses.remove(incorrect)
            if len(responses) != 0:
                False, f"Invalid #6: {eval}"

        return True, f"Valid: {eval}"

if __name__ == "__main__":
    gen = Quizgen()

    topic = "science"
    num_questions = 3
    num_answers = 4
    quiz = gen.gen_quiz("science", num_questions, num_answers)
    #quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_cyprus.json")
    print(json.dumps(quiz, indent=4))

    valid, details = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(valid, details)