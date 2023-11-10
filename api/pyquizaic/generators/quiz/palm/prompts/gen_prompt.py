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

f_prompt = open("prompt.txt", "w")

f_prompt.write("""
Generate a multiple choice trivia quiz containing {num_questions} questions about {topic}, represented in json. Make the questions diverse, avoid repetitive formats, and make sure the correct answers are accurate.

""")

for num_questions in (3, 4, 5):
    for difficulty in ("easy", "medium", "difficult"):
        topic = random.choice(topics)
        quiz = gen.gen_quiz(topic, num_questions=num_questions, difficulty=difficulty)
        quiz = json.dumps(quiz)
        f_prompt.write(f"input: {topic}, {num_questions} questions, {difficulty}\n")
        f_prompt.write("output: " + quiz + "\n\n")

f_prompt.write("input: {topic}, {num_questions} questions, {difficulty}\n")
f_prompt.write("output:\n")
