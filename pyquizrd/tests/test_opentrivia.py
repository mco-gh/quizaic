import json
from generators.quiz.quizgenfactory import QuizgenFactory

def test_opentrivia_gen_quiz():
    topic = "General Knowledge"
    num_questions = 5
    num_answers = 4 # opentrivia always has 4 responses
    gen = QuizgenFactory.get_gen("opentrivia")
    quiz = gen.gen_quiz("General Knowledge", num_questions)
    print(json.dumps(quiz, indent=4))
    assert(quiz != None)

    valid, details = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(details)
    assert valid

def test_eval_quiz_num_questions():
    topic = "General Knowledge"
    num_questions = 5
    num_answers = 4 # opentrivia always has 4 responses
    gen = QuizgenFactory.get_gen("opentrivia")
    quiz = gen.gen_quiz(topic, num_questions)
    print(json.dumps(quiz, indent=4))

    # Remove a question
    quiz.pop()
    print(json.dumps(quiz, indent=4))

    valid, details = gen.eval_quiz(quiz, topic, num_questions, num_answers)
    print(details)
    assert not valid
