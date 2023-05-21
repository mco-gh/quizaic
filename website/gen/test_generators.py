import pytest
import gen

def test_get_gens():
    gens = gen.Generator.get_gens()
    assert(set(gens.keys()) == set(["jeopardy", "opentrivia", "palm", "gpt"]))

def test_create_jeopardy_gen():
    g = gen.Generator("jeopardy")
    s = str(g)
    assert(g != None)
    assert(s == "Jeopardy quiz generator for quizrd.io")

def test_create_palm_gen():
    g = gen.Generator("palm")
    s = str(g)
    assert(g != None)
    assert(s == "Palm quiz generator for quizrd.io")

def test_create_gpt_gen():
    g = gen.Generator("gpt")
    s = str(g)
    assert(g != None)
    assert(s == "GPT quiz generator for quizrd.io")

def test_create_opentriva_gen():
    g = gen.Generator("opentrivia")
    s = str(g)
    assert(g != None)
    assert(s == "OpenTrivia quiz generator for quizrd.io")

def test_create_unsupported_gen():
    with pytest.raises(Exception):
        g = gen.Generator("unsupported")
