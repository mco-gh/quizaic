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

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import json
import random
import sys
import time
import vertexai
from google.cloud import aiplatform_v1

sys.path.append("../../../../../")
from pyquizaic.generators.quiz.quizgenfactory import QuizgenFactory

gen = QuizgenFactory.get_gen("opentrivia")
topics = list(gen.get_topics())


preamble = """
CONTEXT:

You are auditioning for the job of question writer on a TV quiz show. Generate a multiple choice trivia quiz about topic {topic}. All questions and responses should be in {language}.

RULES:
- Accuracy is critically important.
- Quizzes should be <DIFFICULTY>.
- Quizzes should be formatted in json, as shown in the examples.
- Quizzes should contain {num_questions} questions with {num_answers} responses each.
- Do not repeat any questions or any responses within a quiz.
- Each question must have exactly one correct response, selected from the responses array.

EXAMPLES:

"""

for difficulty in ("easy", "medium", "hard"):
    f_prompt = open(f"prompt.{difficulty}", "w")
    if difficulty == "easy":
        preamble2 = preamble.replace("<DIFFICULTY>", "easy")
    elif difficulty == "medium":
        preamble2 = preamble.replace("<DIFFICULTY>", "challenging for a well informed adult")
    elif difficulty == "hard":
        preamble2 = preamble.replace("<DIFFICULTY>", "very difficult!")

    f_prompt.write(preamble2)
    for num_questions in [3]:
        while True:
            topic = random.choice(topics)
            if topic != "Art" and topic != "Gadgets":
                break

        quiz = gen.gen_quiz(topic, num_questions=num_questions, difficulty=difficulty)
        quiz = json.dumps(quiz)
        quiz = quiz.replace("{", "{{")
        quiz = quiz.replace("}", "}}")
        f_prompt.write(f"Input: topic: {topic}, num_questions: {num_questions}, num_answers: 4\n\n")
        f_prompt.write("Output: " + quiz + "\n\n")
    f_prompt.write("Input: topic: {topic}, num_questions: {num_questions}, num_answers: {num_answers}\n\n")
    f_prompt.write("Output:\n")
