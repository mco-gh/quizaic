import gen
g = gen.Generator("jeopardy")
topics = g.get_topics()
quiz = g.gen_quiz("QUOTATIONS", 2, 4)
print(quiz)
