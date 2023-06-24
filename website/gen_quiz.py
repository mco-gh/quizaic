import gen

g = gen.Generator("palm", root="gen")
q = g.gen_quiz("Rock History", 3, 1, 5, .5)
print(q)
