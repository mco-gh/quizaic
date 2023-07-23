from pyquizgen.pyquizgen import Quizgen
import pytest

g = Quizgen("jeopardy")
q = g.gen_quiz("History", 3, 1, 3, .5)
print(q)
