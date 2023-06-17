import gen

g = gen.Generator("palm", root="gen")
q = g.gen_quiz("American History", 3, 1, 4, .5)
print(q)
