from gen import Generator

generator = Generator("jeopardy")
quiz = generator.gen_quiz()
print(quiz)

generator = Generator("bard")
quiz = generator.gen_quiz()
print(quiz)

generator = Generator("chatgpt")
quiz = generator.gen_quiz()
print(quiz)

generator = Generator("opentrivia")
quiz = generator.gen_quiz()
print(quiz)
