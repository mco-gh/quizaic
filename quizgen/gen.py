from quizgen.quizgen import Quizgen

import pytest
from quizgen.quizgen import Quizgen

g = Quizgen("palm")
q = g.gen_quiz("History", 3, 1, 3, .5)
print(q)
