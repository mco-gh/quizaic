import gen

g = gen.Generator("palm", root="gen")
q = g.gen_quiz("US History", 3, 1, 3, .5)
print(q)
