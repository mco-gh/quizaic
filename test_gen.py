import gen
g = gen.Generator("jeopardy")
topics = g.get_topics()
print(topics)
quiz = g.gen_quiz("Quotations", 3, 4)
print(quiz)
