import pytest
import json

from generators.quizgenfactory import QuizgenFactory
from generators.jeopardy.quizgen import Quizgen as JeopardyQuizgen
from generators.opentrivia.quizgen import Quizgen as OpenTriviaQuizgen

# An example of running individual tests with print outputs and verbose testing output:
# pytest test_quizgen.py -v -s -k test_get_gens

def test_get_gens():
    gens = QuizgenFactory.get_gens()
    assert(set(gens.keys()) == QuizgenFactory.GENERATORS.keys())

def test_create_generator():
    for type in QuizgenFactory.GENERATORS:
        gen = QuizgenFactory.get_gen(type)
        assert(gen != None)
        s = str(gen)
        assert(s == f"{type} quiz generator")

def test_get_topics():
    TOPICS = {
        "gpt": set(),
        "jeopardy": JeopardyQuizgen().get_topics(10),
        "manual": set(),
        "opentrivia": set(OpenTriviaQuizgen.TOPICS),
        "palm": set()
    }

    for type in QuizgenFactory.GENERATORS:
        gen = QuizgenFactory.get_gen(type)
        assert(gen != None)
        topics = gen.get_topics(10)
        print(f'gen:{gen} topics:{topics}')
        assert(topics == TOPICS[type])

def test_create_unsupported_gen():
    with pytest.raises(Exception):
        g = QuizgenFactory.get_gen("unsupported")

def test_gpt_gen_quiz():
    # TODO - Currently GPT returns a generic response.
    # Add more checks once it's properly implemented
    gen = QuizgenFactory.get_gen("gpt")
    quiz = gen.gen_quiz("American History", 1, 1)
    print(quiz)
    assert(quiz != None)

def test_jeopardy_gen_quiz():
    expected_num_questions = 5
    gen = QuizgenFactory.get_gen("jeopardy")
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
    gen = QuizgenFactory.get_gen("manual")
    quiz = gen.gen_quiz()
    print(quiz)
    assert(quiz != None)
