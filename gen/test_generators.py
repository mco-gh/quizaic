import pytest
import gen

def test_create_jeopardy_gen():
    g = gen.Generator("jeopardy")
    assert(g != None)

def test_create_bard_gen():
    g = gen.Generator("bard")
    assert(g != None)

def test_create_chatgpt_gen():
    g = gen.Generator("chatgpt")
    assert(g != None)

def test_create_unsupported_gen():
    with pytest.raises(Exception):
        g = gen.Generator("unsupported")
