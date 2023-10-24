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

from generators.quiz.question_grader import QuestionGrader
from generators.quiz.question_grader import AnswerFormat


def test_constructor():
    grader = QuestionGrader()
    assert grader


def test_multiple_choice_correct_answer():
    grader = QuestionGrader()
    grade = grader.grade_answer("correct answer", "correct answer")
    assert grade


def test_multiple_choice_wrong_answer():
    grader = QuestionGrader()
    grade = grader.grade_answer("correct answer", "wrong answer")
    assert not grade


def test_multiple_choice_slightly_wrong_answer():
    grader = QuestionGrader()
    # multiple-choice questions should not tolerate slightly wrong answers
    grade = grader.grade_answer("correct answer", "ccorrect answer")
    assert not grade


def test_free_form_correct_answer():
    grader = QuestionGrader()
    grade = grader.grade_answer(
        "correct answer", "correct answer", AnswerFormat.FREE_FORM
    )
    assert grade


def test_free_form_correct_answer_with_extra():
    grader = QuestionGrader()
    # Correct answer with slight extra characters should be treated as correct
    grade = grader.grade_answer(
        "correct_answer", "correct answer extra", AnswerFormat.FREE_FORM
    )
    assert grade


def test_free_form_wrong_answer():
    grader = QuestionGrader()
    grade = grader.grade_answer(
        "correct answer", "wrong answer", AnswerFormat.FREE_FORM
    )
    assert not grade


def test_free_form_slightly_wrong_answer():
    grader = QuestionGrader()
    grade = grader.grade_answer(
        "correct answer", "ccorrect answer", AnswerFormat.FREE_FORM
    )
    assert grade


def test_free_form_another_slightly_wrong_answer():
    grader = QuestionGrader()
    grade = grader.grade_answer(
        "correct answer", "ccorrect ansswer!", AnswerFormat.FREE_FORM
    )
    assert grade


def test_free_form_wrong_order():
    grader = QuestionGrader()
    # Wrong order of words should be treated as correct
    grade = grader.grade_answer(
        "correct_answer", "answer correct", AnswerFormat.FREE_FORM
    )
    assert grade


def test_free_form_wrong_answer_low_similarity_threshold():
    grader = QuestionGrader(20)
    # This should be graded as correct with the low similarity threshold
    grade = grader.grade_answer(
        "correct answer", "wrong answer", AnswerFormat.FREE_FORM
    )
    assert grade
