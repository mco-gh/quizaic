import pytest
import json
from pyquizrd.pyquizrd import Quizgen

# An example of running individual tests with print outputs and verbose testing
# output:
# pytest test_quizgen.py -v -s -k test_gen_quiz_palm

GENS = {"jeopardy", "opentrivia", "palm", "gpt", "manual"}
TOPICS = {
    "gpt": set(),
    # TODO: This should move to jeopardy.py file?
    "jeopardy": {"American History", "Before & After", "Colleges & Universities",
                 "History", "Literature", "Potpourri", "Science", "Sports",
                 "Word Origins", "World History"},
    "manual": set(),
    # TODO: This should move to opentrivia.py file?
    "opentrivia": {"General Knowledge", "Books", "Film", "Music",
            "Musicals & Theatres", "Television", "Video Games", "Board Games",
            "Science & Nature", "Computers", "Mathematics", "Mythology",
            "Sports", "Geography", "History", "Politics", "Art", "Celebrities",
            "Animals", "Vehicles", "Comics", "Gadgets", "Japanese Anime & Manga",
            "Cartoons &  Animations"},
    "palm": set()
}

def test_get_gens():
    gens = Quizgen.get_gens()
    assert(set(gens.keys()) == GENS)

def test_create_generator():
    for g in GENS:
        gen = Quizgen(g)
        assert(gen != None)
        s = str(gen)
        assert(s == f"{g} quiz generator")

def test_get_topics():
    for g in GENS:
        gen = Quizgen(g)
        assert(gen != None)
        topics = gen.get_topics(10)
        assert(set(topics) == TOPICS[g]) 

def test_create_unsupported_gen():
    with pytest.raises(Exception):
        g = Quizgen("unsupported")

def test_gen_quiz_gpt():
    # TODO - Currently GPT returns a generic response.
    # Add more checks once it's properly implemented
    gen = Quizgen("gpt")
    quiz = gen.gen_quiz("American History", 1, 1, 3, .5)
    print(quiz)
    assert(quiz != None)

def test_gen_quiz_jeopardy():
    expected_num_questions = 5
    gen = Quizgen("jeopardy")
    # TODO - num_answers=1 should not be settable because it's not used
    # difficulty=3, temperature=.5 should be optional but they're not
    quiz = gen.gen_quiz("American History", expected_num_questions, 1, 3, .5)
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
    quiz = gen.gen_quiz("American History", 1, 1, 1, 0)
    print(quiz)
    assert(quiz != None)

def test_gen_quiz_opentrivia():
    expected_num_questions = 5
    gen = Quizgen("opentrivia")
    # TODO - num_answers=1 should not be settable because it's not used
    # difficulty=3, temperature=.5 should be optional but they're not
    quiz = gen.gen_quiz("General Knowledge", expected_num_questions, 1, 3, .5)
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
    # TODO - difficulty=3, temperature=.5 should be optional but they're not
    quiz = gen.gen_quiz("American History", expected_num_questions, expected_num_answers, 3, .5)
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


