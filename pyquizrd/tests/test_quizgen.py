import pytest
import json
from pyquizrd.pyquizrd import Quizgen
from pyquizrd.jeopardy.jeopardy import Quizgen as JeopardyQuizgen
from pyquizrd.opentrivia.opentrivia import Quizgen as OpenTriviaQuizgen

# An example of running individual tests with print outputs and verbose testing
# output:
# pytest test_quizgen.py -v -s -k test_gen_quiz_palm

def test_get_gens():
    gens = Quizgen.get_gens()
    assert(set(gens.keys()) == Quizgen.GENERATORS.keys())

def test_create_generator():
    for g in Quizgen.GENERATORS:
        gen = Quizgen(g)
        assert(gen != None)
        s = str(gen)
        assert(s == f"{g} quiz generator")

def test_get_topics():
    TOPICS = {
        "gpt": set(),
        "jeopardy": JeopardyQuizgen().get_topics(10),
        "manual": set(),
        "opentrivia": set(OpenTriviaQuizgen.TOPICS),
        "palm": set()
    }

    for g in Quizgen.GENERATORS:
        gen = Quizgen(g)
        assert(gen != None)
        topics = gen.get_topics(10)
        print(f'gen:{gen} topics:{topics}')
        assert(topics == TOPICS[g])

def test_create_unsupported_gen():
    with pytest.raises(Exception):
        g = Quizgen("unsupported")

def test_gpt_gen_quiz():
    # TODO - Currently GPT returns a generic response.
    # Add more checks once it's properly implemented
    gen = Quizgen("gpt")
    quiz = gen.gen_quiz("American History", 1, 1)
    print(quiz)
    assert(quiz != None)

def test_jeopardy_gen_quiz():
    expected_num_questions = 5
    gen = Quizgen("jeopardy")
    quiz = gen.gen_quiz("American History", expected_num_questions)
    print(quiz)
    assert(quiz != None)

    quiz = json.loads(quiz)
    actual_num_questions = len(quiz)
    assert(expected_num_questions == actual_num_questions)

    # jeopardy always has a single correct answer
    for question in quiz:
        assert(isinstance(question["correct"], str))

def test_manual_gen_quiz():
    gen = Quizgen("manual")
    quiz = gen.gen_quiz()
    print(quiz)
    assert(quiz != None)

def test_opentrivia_gen_quiz():
    expected_num_questions = 5
    gen = Quizgen("opentrivia")
    quiz = gen.gen_quiz("General Knowledge", expected_num_questions)
    print(quiz)
    assert(quiz != None)

    quiz = json.loads(quiz)
    actual_num_questions = len(quiz)
    assert(expected_num_questions == actual_num_questions)

    # opentrivia always has 4 responses
    expected_num_answers = 4
    for question in quiz:
        actual_num_answers = len(question["responses"])
        assert(expected_num_answers == actual_num_answers)

def test_palm_noconfig():
    # This test passes only if you have access to the project defined in DEFAULT_PROJECT in palm.py
    gen = Quizgen("palm")
    assert(gen != None)

def test_palm_withconfig():
    # This test passes only if you have access to project defined below
    config = {"project": "quizrd-atamel"}
    gen = Quizgen("palm", config)
    assert(gen != None)

def test_palm_eval_quiz_num_questions():
    gen = Quizgen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_americanhistory.json")

    # Remove a question
    quiz.pop()
    print(json.dumps(quiz, indent=4))

    gen = Quizgen("palm")
    valid, details = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(details)
    assert not valid

def test_palm_eval_quiz_num_answers():
    gen = Quizgen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_americanhistory.json")

    # Remove an answer
    quiz[0]["responses"].pop()
    print(json.dumps(quiz, indent=4))

    gen = Quizgen("palm")
    valid, details = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(details)
    assert not valid

def test_palm_eval_quiz_correct_answer_inlist():
    gen = Quizgen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_americanhistory.json")

    # Change correct answer to a value not in responses
    quiz[0]["correct"] = "foo"
    print(json.dumps(quiz, indent=4))

    gen = Quizgen("palm")
    valid, details = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(details)
    assert not valid

def test_palm_eval_quiz_question_on_topic():
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

    gen = Quizgen("palm")
    valid, details = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(details)
    assert not valid

def test_palm_eval_quiz_correct_is_correct():
    gen = Quizgen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_americanhistory.json")

    # Change the second question's answer to a wrong answer in responses
    quiz[1]["correct"] = "Texas"
    print(json.dumps(quiz, indent=4))

    gen = Quizgen("palm")
    valid, details = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(details)
    assert not valid