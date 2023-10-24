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

class BaseQuizeval:

    def __init__(self):
        pass

    def __str__(self):
        return "base quiz evaluator"

    # Given a quiz, check if it's a valid quiz and returns a validity map with details
    def eval_quiz(self, quiz, topic, num_questions, num_answers):
        validity = {
            "valid_quiz": True,
            "valid_questions": set(),
            "invalid_questions": set(),
            "unknown_questions": 0,
            "details": []
        }

        validity = self.check_num_questions(validity, quiz, num_questions)
        if not validity["valid_quiz"]:
            return validity

        validity = self.check_num_answers(validity, quiz, num_questions, num_answers)
        if not validity["valid_quiz"]:
            return validity

        validity = self.check_correct_in_answers(validity, quiz)
        return validity

    @staticmethod
    def check_num_questions(validity, quiz, num_questions):
        actual_num_questions = len(quiz)
        if actual_num_questions != num_questions:
            validity["valid_quiz"] = False
            validity["unknown_questions"] = num_questions
            validity["details"].append(f"Invalid #1: Number of questions does not match - expected: {num_questions}"
                                       f", actual: {actual_num_questions}")
        return validity

    @staticmethod
    def check_num_answers(validity, quiz, num_questions, num_answers):
        for item in quiz:
            question = item['question']
            responses = item["responses"]
            actual_num_answers = len(responses)
            if actual_num_answers != num_answers:
                validity["valid_quiz"] = False
                validity["unknown_questions"] = num_questions
                validity["details"].append(f"Invalid #2: Number of answers does not match - question: '{question}"
                                           f", expected: {num_answers}, actual: {actual_num_answers}")
                return validity
        return validity

    @staticmethod
    def check_correct_in_answers(validity, quiz):
        for item in quiz:
            question = item['question']
            responses = item["responses"]
            correct = item["correct"]
            if correct not in responses:
                validity["valid_quiz"] = False
                validity["invalid_questions"].add(question)
                validity["details"].append(f"Invalid #3: The correct answer is not in the responses list - question: '{question}'"
                                           f", correct:{correct} responses: {responses}")
                return validity
        return validity

    @staticmethod
    def get_validity_compact(validity):
        return {
            "valid_quiz": validity["valid_quiz"],
            "valid_questions": len(validity["valid_questions"]),
            "invalid_questions": len(validity["invalid_questions"]),
            "unknown_questions": validity["unknown_questions"],
            "details": validity["details"]
        }

