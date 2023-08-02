import json
import pytest
import random

from generators.quizgenfactory import QuizgenFactory

def test_noconfig():
    # This test passes only if you have access to the project defined in DEFAULT_PROJECT in palm.py
    gen = QuizgenFactory.get_gen("palm")
    assert(gen != None)

def test_withconfig():
    # This test passes only if you have access to project defined below
    config = {"project": "quizrd-atamel"}
    gen = QuizgenFactory.get_gen("palm", config)
    assert(gen != None)

def test_gen_quiz():
    num_questions = 2
    num_answers = 4
    gen = QuizgenFactory.get_gen("palm")
    quiz = gen.gen_quiz("World History", num_questions, num_answers)
    print(json.dumps(quiz, indent=4))
    assert(quiz != None)

def test_eval_quiz_num_questions():
    gen = QuizgenFactory.get_gen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_americanhistory.json")

    # Remove a question
    quiz.pop()
    print(json.dumps(quiz, indent=4))

    validity = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(validity["details"])
    assert not validity["valid_quiz"]

def test_eval_quiz_num_answers():
    gen = QuizgenFactory.get_gen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_americanhistory.json")

    # Remove an answer
    quiz[0]["responses"].pop()
    print(json.dumps(quiz, indent=4))

    validity = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(validity["details"])
    assert not validity["valid_quiz"]

def test_eval_quiz_correct_answer_inlist():
    gen = QuizgenFactory.get_gen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_americanhistory.json")

    # Change correct answer to a value not in responses
    quiz[0]["correct"] = "foo"
    print(json.dumps(quiz, indent=4))

    validity = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(validity["details"])
    assert not validity["valid_quiz"]

def test_eval_quiz_question_on_topic():
    gen = QuizgenFactory.get_gen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_americanhistory.json")

    # Add a question on an unrelated topic
    quiz.append(
        {
        "question": "What is the capital of Cyprus?",
        "responses": [
            "Nicosia",
            "Limassol",
            "Paphos"
        ],
        "correct": "Nicosia"
    })
    num_questions += 1
    print(json.dumps(quiz, indent=4))

    validity = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(validity["details"])
    assert not validity["valid_quiz"]

def test_eval_quiz_correct_is_correct_cyprus():
    quiz_file = "quiz_cyprus.json"
    wrong_answer = "Paphos"
    do_eval_quiz_correct_is_correct(quiz_file, wrong_answer)

def test_eval_quiz_correct_is_correct_americanhistory():
    quiz_file = "quiz_americanhistory.json"
    wrong_answer = "Georgia"
    do_eval_quiz_correct_is_correct(quiz_file, wrong_answer)

def do_eval_quiz_correct_is_correct(quiz_file, wrong_answer):
    gen = QuizgenFactory.get_gen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz(quiz_file)

    # Change the second question's answer to a wrong answer in responses
    quiz[1]["correct"] = wrong_answer
    print(json.dumps(quiz, indent=4))

    validity = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(validity["details"])
    assert not validity["valid_quiz"]

@pytest.mark.skip(reason="takes a long time to run, only use occasionally for integration testing")
def test_eval_quiz_with_opentrivia_data():
    gen_opentrivia = QuizgenFactory.get_gen("opentrivia")
    gen_palm = QuizgenFactory.get_gen("palm")

    num_quiz = 10
    num_questions = 10
    num_answers = 4 # opentrivia always has 4 responses

    valid_quiz = 0
    invalid_quiz = 0
    valid_questions = 0
    invalid_questions = 0
    unknown_questions = 0

    for i in range(0, num_quiz):
        topic = random.choice(list(gen_opentrivia.get_topics()))
        #topic = "Comics"

        quiz = gen_opentrivia.gen_quiz(topic, num_questions)
        print(f'topic: {topic}, quiz: {json.dumps(quiz, indent=4)}')

        validity = gen_palm.eval_quiz(quiz, topic, num_questions, num_answers, shortcircuit_validity=False)
        print(f'validity: {json.dumps(validity, indent=4)}')

        if validity["valid_quiz"]:
            valid_quiz += 1
        else:
            invalid_quiz += 1
        print(f"total quiz: {valid_quiz + invalid_quiz}, valid: {valid_quiz}, invalid: {invalid_quiz}")

        valid_questions += validity["valid_questions"]
        invalid_questions += validity["invalid_questions"]
        unknown_questions += validity["unknown_questions"]

        print(f"total questions: {valid_questions + invalid_questions + unknown_questions}, valid: {valid_questions}, invalid: {invalid_questions}, unknown: {unknown_questions}")

        #assert validity["valid_quiz"]
