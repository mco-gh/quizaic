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

import json
from generators.quiz.quizgenfactory import QuizgenFactory
from generators.quiz.basequizeval import BaseQuizeval


def test_opentrivia_gen_quiz():
    topic = "General Knowledge"
    num_questions = 5
    num_answers = 4  # opentrivia always has 4 responses
    gen = QuizgenFactory.get_gen("opentrivia")
    quiz = gen.gen_quiz("General Knowledge", num_questions)
    print(json.dumps(quiz, indent=4))
    assert quiz != None


def test_eval_quiz_num_questions():
    topic = "General Knowledge"
    num_questions = 5
    num_answers = 4  # opentrivia always has 4 responses
    gen = QuizgenFactory.get_gen("opentrivia")
    quiz = gen.gen_quiz(topic, num_questions)
    print(json.dumps(quiz, indent=4))

    # Remove a question
    quiz.pop()
    print(json.dumps(quiz, indent=4))

    evaluator = BaseQuizeval()
    validity = evaluator.eval_quiz(quiz, topic, num_questions, num_answers)
    print(validity)
    assert not validity["valid_quiz"]
