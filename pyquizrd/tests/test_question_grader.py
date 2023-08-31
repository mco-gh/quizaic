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
    grade = grader.grade_answer("correct answer", "correct answer", AnswerFormat.FREE_FORM)
    assert grade


def test_free_form_correct_answer_with_extra():
    grader = QuestionGrader()
    # Correct answer with slight extra characters should be treated as correct
    grade = grader.grade_answer("correct_answer", "correct answer extra", AnswerFormat.FREE_FORM)
    assert grade


def test_free_form_wrong_answer():
    grader = QuestionGrader()
    grade = grader.grade_answer("correct answer", "wrong answer", AnswerFormat.FREE_FORM)
    assert not grade


def test_free_form_slightly_wrong_answer():
    grader = QuestionGrader()
    grade = grader.grade_answer("correct answer", "ccorrect answer", AnswerFormat.FREE_FORM)
    assert grade


def test_free_form_another_slightly_wrong_answer():
    grader = QuestionGrader()
    grade = grader.grade_answer("correct answer", "ccorrect ansswer!", AnswerFormat.FREE_FORM)
    assert grade


def test_free_form_wrong_order():
    grader = QuestionGrader()
    # Wrong order of words should be treated as correct
    grade = grader.grade_answer("correct_answer", "answer correct", AnswerFormat.FREE_FORM)
    assert grade