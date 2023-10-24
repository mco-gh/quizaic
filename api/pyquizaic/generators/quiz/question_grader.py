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

from enum import Enum
from thefuzz import fuzz


class AnswerFormat(Enum):
    MULTIPLE_CHOICE = "multiple-choice"
    FREE_FORM = "free-form"


class QuestionGrader:

    # Percentage of similarity used in fuzzy matching to conclude if two string are equal
    DEFAULT_SIMILARITY_THRESHOLD = 80

    def __init__(self, similarity_threshold=DEFAULT_SIMILARITY_THRESHOLD):
        self.similarity_threshold = similarity_threshold

    def __str__(self):
        return "question grader"

    def grade_answer(self, correct_answer: str, player_answer: str, answer_format=AnswerFormat.MULTIPLE_CHOICE) -> bool:
        """Grades the player's answers and returns true/false accordingly.

        Args:
            correct_answer: Correct answer.
            player_answer: Player's answer.
            answer_format: Whether the answer is for a multiple-choice or free-form question.

            In free-form questions, fuzzy matching is applied where similarity above SIMILARITY_SCORE_THRESHOLD is deemed
            to be correct.

        Returns:
            True if the player's answer is correct. In multiple-choice questions, simple string matching is applied.
            In free-form questions, fuzzy string matching is applied where similarity above SIMILARITY_SCORE_THRESHOLD
            is deemed to be correct.
            False if the player's answer is wrong.
        """

        # In multiple-choice question, apply string matching
        if answer_format == AnswerFormat.MULTIPLE_CHOICE:
            return correct_answer == player_answer

        # In free-form question, first, apply string matching
        if correct_answer == player_answer:
            return True

        # Next, apply fuzzy matching
        similarity = fuzz.token_sort_ratio(correct_answer, player_answer)
        print(f"correct: {correct_answer}, player: {player_answer}, similarity: {similarity}")

        return similarity >= self.similarity_threshold

