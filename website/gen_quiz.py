import gen

g = gen.Generator("jeopardy", root="gen")
q = g.gen_quiz("History", 3, 1, 3, .5)
print(q)
