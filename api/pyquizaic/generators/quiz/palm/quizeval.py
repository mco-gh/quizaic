# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import json
import importlib
from vertexai.preview.language_models import TextGenerationModel

import sys

sys.path.append("../../../../")  # Needed for the main method to work in this class
from pyquizaic.generators.quiz.basequizeval import BaseQuizeval
from pyquizaic.generators.quiz.palm.quizgen import Quizgen

# Assumes there's a corresponding eval_*.py for input/output parsing and possibly eval_*.txt if a prompt template exists
PROMPT_VERSION = "eval"
MODEL = "text-bison"
TEMPERATURE = 0
TOP_K = 40
TOP_P = 0.8


class Quizeval(BaseQuizeval):
    def __init__(self):
        super().__init__()

    def __str__(self):
        return "palm quiz evaluator"

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
    def check_prediction_safe(validity, prediction, num_questions):
        if prediction == "":  # Happens when a question is not safe according to LLM
            validity["valid_quiz"] = False
            validity["unknown_questions"] = num_questions
            validity["details"].append(
                "Invalid #4: Cannot evaluate quiz due to unsafe questions"
            )
        return validity

    def eval_quiz(self, quiz, topic, num_questions, num_answers):
        validity = super().eval_quiz(quiz, topic, num_questions, num_answers)
        if not validity["valid_quiz"]:  # if not valid, return before calling LLM
            return self.get_validity_compact(validity)

        module = importlib.import_module(
            f"pyquizaic.generators.quiz.palm.prompts.{PROMPT_VERSION}"
        )
        eval_helper = module.QuizevalHelper()
        print(f"Using quiz eval helper: {eval_helper}")

        # Prepare the input prompt
        prompt = eval_helper.prepare_prompt(quiz, topic)

        prediction = self.predict_llm(MODEL, prompt, TEMPERATURE, 1024, TOP_P, TOP_K)
        print(f"prediction: {prediction}")

        validity = self.check_prediction_safe(validity, prediction, num_questions)
        if not validity["valid_quiz"]:
            return self.get_validity_compact(validity)

        # Parse the output and evaluate
        validity = eval_helper.parse_output_and_eval_quiz(
            validity, prediction, quiz, topic
        )

        return self.get_validity_compact(validity)


if __name__ == "__main__":
    evaluator = Quizeval()
    print(f"eval:{eval}")

    gen = Quizgen()
    topic = "science"
    num_questions = 3
    num_answers = 4
    quiz = gen.gen_quiz("science", num_questions, num_answers)
    print(json.dumps(quiz, indent=4))

    validity = evaluator.eval_quiz(quiz, topic, num_questions, num_answers)
    print(json.dumps(validity, indent=4))
