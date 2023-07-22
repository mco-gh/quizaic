import pytest
from quizgen.quizgen import Quizgen


def test_topics():
    g = Quizgen("jeopardy")
    print(g.get_topics(10))
    assert(g.get_topics(10) == ['American History', 'Before & After', 'Colleges & Universities', 'History', 'Literature', 'Potpourri', 'Science', 'Sports', 'Word Origins', 'World History'])

def test_get_gens():
    gens = Quizgen.get_gens(".")
    assert(set(gens.keys()) == set(["jeopardy", "opentrivia", "palm", "gpt", "manual"]))

def test_create_jeopardy_gen():
    g = Quizgen("jeopardy", root=".")
    topics = g.get_topics()
    s = str(g)
    assert(g != None)
    assert(s == "Jeopardy quiz generator for quizrd.io")

def test_create_palm_gen():
    g = Quizgen("palm", root=".")
    s = str(g)
    assert(g != None)
    assert(s == "Palm quiz generator for quizrd.io")

def test_create_gpt_gen():
    g = Quizgen("gpt", root=".")
    s = str(g)
    assert(g != None)
    assert(s == "GPT quiz generator for quizrd.io")

def test_create_opentriva_gen():
    g = Quizgen("opentrivia", root=".")
    s = str(g)
    assert(g != None)
    assert(s == "OpenTrivia quiz generator for quizrd.io")

def test_create_manual_gen():
    g = Quizgen("manual", root=".")
    s = str(g)
    assert(g != None)
    assert(s == "Manual quiz generator for quizrd.io")

def test_create_unsupported_gen():
    with pytest.raises(Exception):
        g = Quizgen("unsupported")

def test_jeopardy_gen_quiz():
    g = Quizgen("jeopardy", root=".")
    q = g.gen_quiz("History", 10, 1)
