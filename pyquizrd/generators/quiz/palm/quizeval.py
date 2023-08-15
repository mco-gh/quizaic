import copy
import json
import os
from vertexai.preview.language_models import TextGenerationModel

import sys
sys.path.append("../../../../") # Needed for the main method to work in this class
from pyquizrd.generators.quiz.basequizeval import BaseQuizeval
from pyquizrd.generators.quiz.palm.quizgen import Quizgen

MODEL = "text-bison"
PROMPT_FILE = "eval_4.txt"
TEMPERATURE = 0.3
TOP_K = 40
TOP_P = 1


class Quizeval(BaseQuizeval):

    def __init__(self):
        super().__init__()
        file_path = os.path.join(os.path.dirname(__file__), "prompts/" + PROMPT_FILE)
        with open(file_path, encoding='utf-8') as fp:
            self.prompt_template = fp.read()

    def __str__(self):
        return "palm quiz evaluator"

    @staticmethod
    def predict_llm(model, prompt, temperature, max_output_tokens, top_p, top_k, tuned_model=""):
        model = TextGenerationModel.from_pretrained(model)
        if tuned_model:
            model = model.get_tuned_model(tuned_model)
        response = model.predict(prompt, temperature=temperature, max_output_tokens=max_output_tokens, top_k=top_k,
                                 top_p=top_p)
        return response.text

    def eval_quiz(self, quiz, topic, num_questions, num_answers, shortcircuit_validity=True):
        validity = super().eval_quiz(quiz, topic, num_questions, num_answers, shortcircuit_validity)
        if not validity["valid_quiz"] and shortcircuit_validity:
            return self.get_validity_compact(validity)

        # Remove correct answer from each question to not bias the LLM during eval
        quiz_eval = copy.deepcopy(quiz)
        for item in quiz_eval:
            item.pop("correct")

        prompt = self.prompt_template.format(quiz=json.dumps(quiz_eval, indent=4), topic=topic)
        prediction = self.predict_llm(MODEL, prompt, TEMPERATURE, 1024, TOP_P, TOP_K)
        try:
            if prediction == "":  # Happens when a question is not safe according to LLM
                validity["valid_quiz"] = False
                validity["unknown_questions"] = num_questions
                validity["details"].append("Invalid #4: Cannot evaluate quiz due to unsafe questions")
                return self.get_validity_compact(validity)

            # Sometimes the model returns invalid JSON with a trailing comma, remove it.
            if prediction[-3:] == ",\n]":
                prediction = prediction[:-3] + "\n]"

            evaluation = json.loads(prediction)
        except ValueError as e:
            print(f'prediction:"{prediction}"')
            raise ValueError("An exception occurred during JSON parsing", e)

        # [{"on_topic": true, "correct": ["George Washington"], "incorrect": ["Benjamin Franklin", "Thomas Jefferson"]},
        for index, item in enumerate(evaluation):
            question = quiz[index]['question']

            if not item["on_topic"]:
                validity["valid_quiz"] = False
                validity["invalid_questions"].add(question)
                validity["details"].append(f"Invalid #5: The question is not on the topic - question: '{question}'"
                                           f", topic: {topic}")
                if shortcircuit_validity:
                    return self.get_validity_compact(validity)

            expected_correct = item["correct"]
            actual_correct = quiz[index]["correct"]
            if expected_correct != actual_correct:
                validity["valid_quiz"] = False
                validity["invalid_questions"].add(question)
                validity["details"].append(f"Invalid #6: The correct answer is not correct - question: '{question}"
                                           f"', expected: {expected_correct}, actual: {actual_correct}")
                if shortcircuit_validity:
                    return self.get_validity_compact(validity)

            # Only add for eval_3.txt
            # responses = quiz_eval[index]["responses"]
            # if item["correct"] in responses:
            #     responses.remove(item["correct"])
            # for incorrect in item["incorrect"]:
            #     if incorrect in responses:
            #         responses.remove(incorrect)
            # if len(responses) != 0:
            #     validity["valid_quiz"] = False
            #     validity["invalid_questions"].add(question)
            #     validity["details"].append(f"Invalid #7: The rest of responses are not incorrect in question: '{question}'")
            #     if shortcircuit_validity:
            #         return get_validity_compact(validity)

            if question not in validity["invalid_questions"]:
                validity["valid_questions"].add(question)

        return self.get_validity_compact(validity)


if __name__ == "__main__":
    evaluator = Quizeval()
    print(f'eval:{eval}')

    gen = Quizgen()
    topic = "science"
    num_questions = 3
    num_answers = 4
    quiz = gen.gen_quiz("science", num_questions, num_answers)
    print(json.dumps(quiz, indent=4))

    validity = evaluator.eval_quiz(quiz, topic, num_questions, num_answers)
    print(json.dumps(validity, indent=4))
