import pytest
from quizgen.quizgen import Quizgen


GENS = {"jeopardy", "opentrivia", "palm", "gpt", "manual"}
TOPICS = {
    "gpt": set(),
    "jeopardy": {"American History", "Before & After", "Colleges & Universities",
                 "History", "Literature", "Potpourri", "Science", "Sports",
                 "Word Origins", "World History"},
    "manual": set(),
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

def test_jeopardy_gen_quiz():
    g = Quizgen("jeopardy")
    q = g.gen_quiz("History", 10, 1, 3, .5)
