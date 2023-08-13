import copy
import json
import os
import random
import re
import vertexai
from vertexai.preview.language_models import TextGenerationModel

import sys
sys.path.append("../../../../") # Needed for the main method to work in this class
from pyquizrd.generators.quiz.basequizgen import BaseQuizgen

DEFAULT_PROMPT_GEN_FILE = "prompt_gen2.txt"
DEFAULT_PROMPT_EVAL_FILE = "prompt_eval3.txt"

class Quizgen(BaseQuizgen):

    def __init__(self, config=None):
        prompt_gen_file = DEFAULT_PROMPT_GEN_FILE
        prompt_eval_file = DEFAULT_PROMPT_EVAL_FILE

        if config:
            project_id = config.get("project_id")
            region = config.get("region")
            print(f"quizgen init with {project_id}, {region}")
            prompt_gen_file = config.get("prompt_gen_file", DEFAULT_PROMPT_GEN_FILE)
            prompt_eval_file = config.get("prompt_eval_file", DEFAULT_PROMPT_EVAL_FILE)
            vertexai.init(project=project_id, location=region)

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

    # Load quiz from a quiz_<topic>.json file, mainly for testing
    def load_quiz(self, quiz_file):
        file = open(os.path.join(os.path.dirname(__file__), "quizzes/" + quiz_file))
        quiz = json.load(file)
        #print(json.dumps(quiz, indent=4))

        topic = re.search(r"_(.*)\.json", quiz_file).group(1)
        num_questions = len(quiz)
        num_answers = len(quiz[0]["responses"])

        return quiz, topic, num_questions, num_answers

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

    # Given a quiz, check if it's a valid quiz and returns a validity map with
    # details. shortcircuit_validity determines if the validity check returns
    # immediately when an invalid question is found. Set it to false, for testing.
    def eval_quiz(self, quiz, topic, num_questions, num_answers, shortcircuit_validity=True):
        validity = {
            "valid_quiz": True,
            "valid_questions": set(),
            "invalid_questions": set(),
            "unknown_questions": 0,
            "details": []
        }

        actual_num_questions = len(quiz)
        if actual_num_questions != num_questions:
            validity["valid_quiz"] = False
            validity["unknown_questions"] = num_questions
            validity["details"].append(f"Invalid #1: Number of questions does not match - expected: {num_questions} actual: {actual_num_questions}")
            if shortcircuit_validity:
                return get_validity_compact(validity)

        for item in quiz:
            question = item['question']
            responses = item["responses"]
            actual_num_answers = len(responses)
            if actual_num_answers != num_answers:
                validity["valid_quiz"] = False
                validity["unknown_questions"] = num_questions
                validity["details"].append(f"Invalid #2: Number of answers does not match - question: '{question}' expected: {num_answers}, actual: {actual_num_answers}")
                if shortcircuit_validity:
                    return get_validity_compact(validity)

            correct = item["correct"]
            if not correct in responses:
                validity["valid_quiz"] = False
                validity["invalid_questions"].add(question)
                validity["details"].append(f"Invalid #3: The correct answer is not in the responses list - question: '{question}', correct:{correct} responses: {responses}")
                if shortcircuit_validity:
                    return get_validity_compact(validity)

        # Remove correct answer from each question to not bias the LLM during eval
        quiz_eval = copy.deepcopy(quiz)
        for item in quiz_eval:
            item.pop("correct")

        prompt_eval = self.prompt_eval.format(quiz=json.dumps(quiz_eval, indent=4), topic=topic)
        temp = 0 # To get consistent results in evaluation
        eval = self.predict_llm("text-bison@001", temp, 1024, 0.8, 40, prompt_eval)
        try:
            if eval == "": # Happens when a question is not safe according to LLM
                validity["valid_quiz"] = False
                validity["unknown_questions"] = num_questions
                validity["details"].append("Invalid #4: Cannot evaluate quiz due to unsafe questions")
                return get_validity_compact(validity)

            # Hack: Sometimes the LLM returns invalid JSON with a
            # trailing comma. Until the prompt is fixed, remove it.
            if eval[:-3] == ",\n]":
                # Replace the last three characters with "\n]"
                eval = eval[:-3] + "\n]"

            eval = json.loads(eval)
        except ValueError as e:
            print(f'eval:"{eval}"')
            raise ValueError("An exception occurred during JSON parsing", e)

        # [{"on_topic": true, "correct": ["George Washington"], "incorrect": ["Benjamin Franklin", "Thomas Jefferson"]},
        for index, item in enumerate(eval):
            question = quiz[index]['question']

            if not item["on_topic"]:
                validity["valid_quiz"] = False
                validity["invalid_questions"].add(question)
                validity["details"].append(f"Invalid #5: The question is not on the topic - question: '{question}', topic: {topic}")
                if shortcircuit_validity:
                    return get_validity_compact(validity)

            expected_correct = item["correct"]
            actual_correct = quiz[index]["correct"]
            if expected_correct != actual_correct:
                validity["valid_quiz"] = False
                validity["invalid_questions"].add(question)
                validity["details"].append(f"Invalid #6: The correct answer is not correct - question: '{question}', expected: {expected_correct}, actual: {actual_correct}")
                if shortcircuit_validity:
                    return get_validity_compact(validity)

            responses = quiz_eval[index]["responses"]
            if item["correct"] in responses:
                responses.remove(item["correct"])
            for incorrect in item["incorrect"]:
                if incorrect in responses:
                    responses.remove(incorrect)
            if len(responses) != 0:
                validity["valid_quiz"] = False
                validity["invalid_questions"].add(question)
                validity["details"].append(f"Invalid #7: The rest of responses are not incorrect in question: '{question}'")
                if shortcircuit_validity:
                    return get_validity_compact(validity)

            if question not in validity["invalid_questions"]:
                validity["valid_questions"].add(question)

        return get_validity_compact(validity)

def get_validity_compact(validity):
    return {
        "valid_quiz": validity["valid_quiz"],
        "valid_questions": len(validity["valid_questions"]),
        "invalid_questions": len(validity["invalid_questions"]),
        "unknown_questions": validity["unknown_questions"],
        "details": validity["details"]
    }

if __name__ == "__main__":
    gen = Quizgen()
    print(f'gen:{gen}')
    exit(0)

    prompt = "question: In the DC Comics 2016 reboot, Rebirth, which speedster escaped from the Speed Force after he had been erased from existance? Eobard Thawne?"
    result = gen.predict_llm("text-bison@001", 0, 1024, 0.8, 40, prompt)
    print(f'result:{result == ""}')
    exit()

    topic = "science"
    num_questions = 3
    num_answers = 4
    quiz = gen.gen_quiz("science", num_questions, num_answers)
    #quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_cyprus.json")
    print(json.dumps(quiz, indent=4))

    valid, details = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(valid, details)
