from quizgen.quizgen import Quizgen

quiz = Quizgen("jeopardy")
print(quiz)
q = quiz.gen_quiz(topic="History", num_questions=3, num_answers=1, difficulty=5, temperature=.5)
print(q)
