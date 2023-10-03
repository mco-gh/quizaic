import copy
import json
import os
import random
import re
from vertexai.preview.language_models import TextGenerationModel

import sys

sys.path.append("../../../../")  # Needed for the main method to work in this class
from pyquizaic.generators.quiz.basequizgen import BaseQuizgen

MODEL = "text-bison"
PROMPT_FILE = "gen_3.txt"
TEMPERATURE = 0.5
LANGUAGE = "English"
TOP_P = 0.8
TOP_K = 40


class Quizgen(BaseQuizgen):
    def __init__(self, config=None):
        # This doesn't seem to be needed
        # vertexai.init(project=project_id, location=region)

        self.topics = set()

        file_path = os.path.join(os.path.dirname(__file__), "prompts/" + PROMPT_FILE)
        with open(file_path, encoding="utf-8") as fp:
            self.prompt_template = fp.read()

    def __str__(self):
        return "palm quiz generator"

    def get_topics(self, num=None):
        return self.topics

    def get_topic_formats(self):
        return ["free-form"]

    def get_answer_formats(self):
        return ["free-form", "multiple-choice"]

    @staticmethod
    def predict_llm(
        model, prompt, temperature, max_output_tokens, top_p, top_k, tuned_model=""
    ):
        model = TextGenerationModel.from_pretrained(model)
        if tuned_model:
            model = model.get_tuned_model(tuned_model)
        response = model.predict(
            prompt,
            temperature=temperature,
            max_output_tokens=max_output_tokens,
            top_k=top_k,
            top_p=top_p,
        )
        return response.text

    @staticmethod
    def get_difficulty_word(difficulty):
        if difficulty < 1 or difficulty > 5:
            raise Exception("Difficulty cannot be less than 1 or more than 5")

        if difficulty <= 2:
            return "easy"
        elif difficulty <= 4:
            return "medium"
        elif difficulty <= 5:
            return "difficult"

    # Load quiz from a quiz_<topic>.json file, mainly for testing
    @staticmethod
    def load_quiz(quiz_file):
        file = open(os.path.join(os.path.dirname(__file__), "quizzes/" + quiz_file))
        quiz = json.load(file)

        topic = re.search(r"_(.*)\.json", quiz_file).group(1)
        num_questions = len(quiz)
        num_answers = len(quiz[0]["responses"])

        return quiz, topic, num_questions, num_answers

    def gen_quiz(
        self, topic, num_questions, num_answers, difficulty=3, language=LANGUAGE, temperature=TEMPERATURE
    ):
        print(f"{topic=}, {num_questions=}, {num_answers=}, {difficulty=}, {language=}")
        prompt = self.prompt_template.format(
            topic=topic,
            num_questions=num_questions,
            num_answers=num_answers,
            difficulty=self.get_difficulty_word(difficulty),
            language=language
        )
        prediction = self.predict_llm(MODEL, prompt, temperature, 1024, TOP_P, TOP_K)
        quiz = json.loads(prediction)
        # Make sure the correct answer appears randomly in responses
        for i in quiz:
            random.shuffle(i["responses"])
        return quiz


if __name__ == "__main__":
    gen = Quizgen()
    # print(f'gen:{gen}')
    # exit(0)

    # prompt = "question: In the DC Comics 2016 reboot, Rebirth, which speedster escaped from the Speed Force after he had been erased from existance? Eobard Thawne?"
    # result = gen.predict_llm(MODEL, 0, 1024, 0.8, 40, prompt)
    # print(f'result:{result == ""}')
    # exit()

    topic = "science"
    num_questions = 3
    num_answers = 4
    quiz = gen.gen_quiz("science", num_questions, num_answers)
    # quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_cyprus.json")
    print(json.dumps(quiz, indent=4))
