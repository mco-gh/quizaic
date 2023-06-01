import pytest
import gen


def test_topics():
    g = gen.Generator("jeopardy", root=".")
    print(g.get_topics(10))
    assert(g.get_topics(10) == ['American History', 'Before & After', 'Colleges & Universities', 'History', 'Literature', 'Potpourri', 'Science', 'Sports', 'Word Origins', 'World History'])

def test_get_gens():
    gens = gen.Generator.get_gens(".")
    assert(set(gens.keys()) == set(["jeopardy", "opentrivia", "palm", "gpt", "manual"]))

def test_create_jeopardy_gen():
    g = gen.Generator("jeopardy", root=".")
    topics = g.get_topics()
    s = str(g)
    assert(g != None)
    assert(s == "Jeopardy quiz generator for quizrd.io")

def test_create_palm_gen():
    g = gen.Generator("palm", root=".")
    s = str(g)
    assert(g != None)
    assert(s == "Palm quiz generator for quizrd.io")

def test_create_gpt_gen():
    g = gen.Generator("gpt", root=".")
    s = str(g)
    assert(g != None)
    assert(s == "GPT quiz generator for quizrd.io")

def test_create_opentriva_gen():
    g = gen.Generator("opentrivia", root=".")
    s = str(g)
    assert(g != None)
    assert(s == "OpenTrivia quiz generator for quizrd.io")

def test_create_manual_gen():
    g = gen.Generator("manual", root=".")
    s = str(g)
    assert(g != None)
    assert(s == "Manual quiz generator for quizrd.io")

def test_create_unsupported_gen():
    with pytest.raises(Exception):
        g = gen.Generator("unsupported")

def test_jeopardy_gen_quiz():
    g = gen.Generator("jeopardy", root=".")
    q = g.gen_quiz("History", 10, 1)
