# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import copy
import json
import random

from generators.quiz.quizgenfactory import QuizgenFactory
from generators.quiz.palm.quizeval import Quizeval


def test_gen_quiz():
    num_questions = 2
    num_answers = 4
    gen = QuizgenFactory.get_gen("palm")
    quiz = gen.gen_quiz("World History", num_questions, num_answers)
    print(json.dumps(quiz, indent=4))
    assert(quiz != None)


def test_eval_quiz_num_questions():
    gen = QuizgenFactory.get_gen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_americanhistory.json")

    # Remove a question
    quiz.pop()
    print(json.dumps(quiz, indent=4))

    evaluator = Quizeval()
    validity = evaluator.eval_quiz(quiz, topic, num_questions, num_answers)
    print(validity["details"])
    assert not validity["valid_quiz"]


def test_eval_quiz_num_answers():
    gen = QuizgenFactory.get_gen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_americanhistory.json")

    # Remove an answer
    quiz[0]["responses"].pop()
    print(json.dumps(quiz, indent=4))

    evaluator = Quizeval()
    validity = evaluator.eval_quiz(quiz, topic, num_questions, num_answers)
    print(validity["details"])
    assert not validity["valid_quiz"]


def test_eval_quiz_correct_answer_inlist():
    gen = QuizgenFactory.get_gen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_americanhistory.json")

    # Change correct answer to a value not in responses
    quiz[0]["correct"] = "foo"
    print(json.dumps(quiz, indent=4))

    evaluator = Quizeval()
    validity = evaluator.eval_quiz(quiz, topic, num_questions, num_answers)
    print(validity["details"])
    assert not validity["valid_quiz"]


def test_eval_quiz_question_on_topic():
    gen = QuizgenFactory.get_gen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz("quiz_americanhistory.json")

    # Add a question on an unrelated topic
    quiz.append(
        {
        "question": "What is the capital of Cyprus?",
        "responses": [
            "Nicosia",
            "Limassol",
            "Paphos"
        ],
        "correct": "Nicosia"
    })
    num_questions += 1
    print(json.dumps(quiz, indent=4))

    evaluator = Quizeval()
    validity = evaluator.eval_quiz(quiz, topic, num_questions, num_answers)
    print(validity["details"])
    assert not validity["valid_quiz"]


def test_eval_quiz_correct_is_correct_cyprus():
    quiz_file = "quiz_cyprus.json"
    wrong_answer = "Paphos"
    do_eval_quiz_correct_is_correct(quiz_file, wrong_answer)


def test_eval_quiz_correct_is_correct_americanhistory():
    quiz_file = "quiz_americanhistory.json"
    wrong_answer = "Georgia"
    do_eval_quiz_correct_is_correct(quiz_file, wrong_answer)


def do_eval_quiz_correct_is_correct(quiz_file, wrong_answer):
    gen = QuizgenFactory.get_gen("palm")
    quiz, topic, num_questions, num_answers = gen.load_quiz(quiz_file)

    # Change the second question's answer to a wrong answer in responses
    quiz[1]["correct"] = wrong_answer
    print(json.dumps(quiz, indent=4))

    evaluator = Quizeval()
    validity = evaluator.eval_quiz(quiz, topic, num_questions, num_answers)
    print(validity["details"])
    assert not validity["valid_quiz"]


def test_eval_quiz_with_opentrivia_data():
    gen_opentrivia = QuizgenFactory.get_gen("opentrivia")
    evaluator = Quizeval()

    num_quiz = 1
    num_questions = 10
    num_answers = 4 # opentrivia always has 4 responses

    valid_quiz = 0
    invalid_quiz = 0
    valid_questions = 0
    invalid_questions = 0
    unknown_questions = 0

    for i in range(0, num_quiz):
        topic = random.choice(list(gen_opentrivia.get_topics()))

        quiz = gen_opentrivia.gen_quiz(topic, num_questions)
        print(f'topic: {topic}, quiz: {json.dumps(quiz, indent=4)}')

        validity = evaluator.eval_quiz(quiz, topic, num_questions, num_answers)
        print(f'validity: {json.dumps(validity, indent=4)}')

        if validity["valid_quiz"]:
            valid_quiz += 1
        else:
            invalid_quiz += 1
        print(f"total quiz: {valid_quiz + invalid_quiz}, valid: {valid_quiz}, invalid: {invalid_quiz}")

        valid_questions += validity["valid_questions"]
        invalid_questions += validity["invalid_questions"]
        unknown_questions += validity["unknown_questions"]

        print(f"total questions: {valid_questions + invalid_questions + unknown_questions}, valid: {valid_questions}, invalid: {invalid_questions}, unknown: {unknown_questions}")

def test_eval_quiz_with_perturbed_opentrivia_data():
    gen_opentrivia = QuizgenFactory.get_gen("opentrivia")
    evaluator = Quizeval()

    num_quiz = 1
    num_questions = 3
    num_perturbed_answers = 1
    num_answers = 4 # opentrivia always has 4 responses

    valid_quiz = 0
    invalid_quiz = 0
    valid_questions = 0
    invalid_questions = 0
    unknown_questions = 0

    for i in range(0, num_quiz):
        topic = random.choice(list(gen_opentrivia.get_topics()))

        quiz = gen_opentrivia.gen_quiz(topic, num_questions)
        print(f'topic: {topic}, quiz: {json.dumps(quiz, indent=4)}')

        perturbed_quiz = perturbe_quiz(quiz, num_perturbed_answers)
        print(f'perturbed_quiz: {json.dumps(perturbed_quiz, indent=4)}')

        validity = evaluator.eval_quiz(perturbed_quiz, topic, num_questions, num_answers)
        print(f'validity: {json.dumps(validity, indent=4)}')

        if validity["valid_quiz"]:
            valid_quiz += 1
        else:
            invalid_quiz += 1
        print(f"total quiz: {valid_quiz + invalid_quiz}, valid: {valid_quiz}, invalid: {invalid_quiz}")

        valid_questions += validity["valid_questions"]
        invalid_questions += validity["invalid_questions"]
        unknown_questions += validity["unknown_questions"]

        print(f"total questions: {valid_questions + invalid_questions + unknown_questions}, valid: {valid_questions}, invalid: {invalid_questions}, unknown: {unknown_questions}")

def perturbe_quiz(quiz, n):

    perturbed_quiz = copy.deepcopy(quiz)

    # Sample n unique random items from the list
    sampled_items = random.sample(perturbed_quiz, n)

    for random_item in sampled_items:
        # Remove the current correct answer from the responses
        new_responses = [response for response in random_item["responses"] if response != random_item["correct"]]

        # Shuffle the new responses list
        random.shuffle(new_responses)

        # Choose a new correct answer from the shuffled responses
        new_correct_answer = new_responses.pop()

        # Update the item with the new correct answer
        random_item["correct"] = new_correct_answer

    return perturbed_quiz
