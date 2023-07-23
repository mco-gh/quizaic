from pyquizrd.pyquizrd import Quizgen
import pytest

g = Quizgen("palm")
q = g.gen_quiz("History", 3, 1, 3, .5)
print(q)
