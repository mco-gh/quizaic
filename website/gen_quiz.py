import gen

g = gen.Generator("palm", root="gen")
q = g.gen_quiz(topic="Rock History", num_questions=3, num_answers=1, difficulty=5, temperature=.5)
print(q)
