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

def test_gen_quiz_gpt():
    # TODO - Currently GPT returns a generic response.
    # Add more checks once it's properly implemented
    gen = Quizgen("gpt")
    quiz = gen.gen_quiz("American History", 1, 1)
    print(quiz)
    assert(quiz != None)

def test_gen_quiz_jeopardy():
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

def test_gen_quiz_manual():
    gen = Quizgen("manual")
    quiz = gen.gen_quiz()
    print(quiz)
    assert(quiz != None)

def test_gen_quiz_opentrivia():
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

def test_gen_quiz_palm():
    expected_num_questions = 5
    expected_num_answers = 3
    gen = Quizgen("palm")
    quiz = gen.gen_quiz("American History", expected_num_questions, expected_num_answers)
    print(quiz)
    assert(quiz != None)

    quiz = json.loads(quiz)
    actual_num_questions = len(quiz)
    assert(expected_num_questions == actual_num_questions)

    for question in quiz:
        # TODO - This currently fails with prompt.txt, passes with prompt2.txt
        actual_num_answers = len(question["responses"])
        assert(expected_num_answers == actual_num_answers)

        assert(question["correct"] in question["responses"])


