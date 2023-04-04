import pytest
import gen

def test_get_gens():
    gens = gen.Generator.gens()
    assert(gens == set(["jeopardy", "opentrivia", "bard", "chatgpt"]))

def test_create_jeopardy_gen():
    g = gen.Generator("jeopardy")
    s = str(g)
    assert(g != None)
    assert(s == "Jeopardy Generator")

def test_create_bard_gen():
    g = gen.Generator("bard")
    s = str(g)
    assert(g != None)
    assert(s == "Bard Generator")

def test_create_chatgpt_gen():
    g = gen.Generator("chatgpt")
    s = str(g)
    assert(g != None)
    assert(s == "ChatGPT Generator")

def test_create_opentriva_gen():
    g = gen.Generator("opentrivia")
    s = str(g)
    assert(g != None)
    assert(s == "OpenTrivia Generator")

def test_create_unsupported_gen():
    with pytest.raises(Exception):
        g = gen.Generator("unsupported")
