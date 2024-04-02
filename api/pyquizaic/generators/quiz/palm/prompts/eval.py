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

import copy
import json
import os


# eval6 prompt uses a more freeform input and no prompt template:
# question: What is the name of the largest planet in the solar system? Jupiter, Saturn, Uranus, Neptune
# correct: <find correct answer>
#
# question: What is the name of the smallest planet in the solar system? Venus, Earth, Mercury, Mars?
# correct: <find correct answer>
#
# Return correct answers in JSON: [
#    <answer>,
#    ...
# ]
class QuizevalHelper:
    def __init__(self):
        pass

    def __str__(self):
        return "eval"

    @staticmethod
    def prepare_prompt(quiz, topic):
        prompt = ""
        for item in quiz:
            prompt += (
                f"\nquestion: {item['question']} {', '.join(item['responses'])}\n"
                + "correct: <find correct answer>\n"
            )
        prompt += """\nReturn correct answers in this format: 
        [
            <answer>,
            <answer>,
            ...
        ]"""
        print(f"prompt: {prompt}")

        return prompt

    @staticmethod
    def parse_output_and_eval_quiz(validity, prediction, quiz, topic):
        # [
        #     "<answer1>"
        #     "<answer2>
        # ],
        evaluation = json.loads(prediction)

        for index, item in enumerate(evaluation):
            question = quiz[index]["question"]

            expected_correct = item
            actual_correct = quiz[index]["correct"]
            if expected_correct != actual_correct:
                validity["valid_quiz"] = False
                validity["invalid_questions"].add(question)
                validity["details"].append(
                    f"Invalid #6: The correct answer is not correct - question: '{question}"
                    f"', expected: {expected_correct}, actual: {actual_correct}"
                )

            if question not in validity["invalid_questions"]:
                validity["valid_questions"].add(question)

        return validity
