import json
from pyquizrd.pyquizrd import Quizgen

def test_noconfig():
    # This test passes only if you have access to the project defined in DEFAULT_PROJECT in palm.py
    gen = Quizgen("palm")
    assert(gen != None)

def test_withconfig():
    # This test passes only if you have access to project defined below
    config = {"project": "quizrd-atamel"}
    gen = Quizgen("palm", config)
    assert(gen != None)

def test_gen_quiz():
    num_questions = 2
    num_answers = 4
    gen = Quizgen("palm")
    quiz = gen.gen_quiz("World History", num_questions, num_answers)
    print(json.dumps(quiz, indent=4))
    assert(quiz != None)

def test_eval_quiz_num_questions():
    gen = Quizgen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_americanhistory.json")

    # Remove a question
    quiz.pop()
    print(json.dumps(quiz, indent=4))

    valid, details = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(details)
    assert not valid

def test_eval_quiz_num_answers():
    gen = Quizgen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_americanhistory.json")

    # Remove an answer
    quiz[0]["responses"].pop()
    print(json.dumps(quiz, indent=4))

    valid, details = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(details)
    assert not valid

def test_eval_quiz_correct_answer_inlist():
    gen = Quizgen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_americanhistory.json")

    # Change correct answer to a value not in responses
    quiz[0]["correct"] = "foo"
    print(json.dumps(quiz, indent=4))

    valid, details = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(details)
    assert not valid

def test_eval_quiz_question_on_topic():
    gen = Quizgen("palm")
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

    valid, details = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(details)
    assert not valid

def test_eval_quiz_correct_is_correct_cyprus():
    quiz_file = "quiz_cyprus.json"
    wrong_answer = "Paphos"
    do_eval_quiz_correct_is_correct(quiz_file, wrong_answer)

def test_eval_quiz_correct_is_correct_americanhistory():
    quiz_file = "quiz_americanhistory.json"
    wrong_answer = "Georgia"
    do_eval_quiz_correct_is_correct(quiz_file, wrong_answer)

def do_eval_quiz_correct_is_correct(quiz_file, wrong_answer):
    gen = Quizgen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz(quiz_file)

    # Change the second question's answer to a wrong answer in responses
    quiz[1]["correct"] = wrong_answer
    print(json.dumps(quiz, indent=4))

    valid, details = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(details)
    assert not valid