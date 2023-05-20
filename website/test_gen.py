import gen
import json
import pytest


def test_jeopardy_topics():
    g = gen.Generator("jeopardy")
    topics = g.get_topics()
    quiz = g.gen_quiz("Quotations", 3, 4)
    print(json.dumps(json.loads(quiz), indent=4))

def test_get_gens():
    gens = gen.Generator.gens()
    assert(gens == set(["jeopardy", "opentrivia", "palm", "chatgpt"]))

def test_create_jeopardy_gen():
    g = gen.Generator("jeopardy")
    s = str(g)
    assert(g != None)
    assert(s == "Jeopardy Generator")

def test_create_palm_gen():
    g = gen.Generator("palm")
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
