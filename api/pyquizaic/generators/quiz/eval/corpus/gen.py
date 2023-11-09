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
from vertexai.language_models import TextGenerationModel

sys.path.append("../../../../../")
from pyquizaic.generators.quiz.quizgenfactory import QuizgenFactory

gen = QuizgenFactory.get_gen("opentrivia")

num_questions = 1000
questions_per_quiz = 5
count = 0
qa = []
labels = []
seen = {}

# Generate QA and labels.
topics = list(gen.get_topics())

f_questions = open("questions.mc.good.txt", "w")
while count < num_questions:
    topic = random.choice(topics)
    quiz = gen.gen_quiz(topic, questions_per_quiz)
    for question in quiz:
        q = question["question"]
        if q in seen:
            print("skipping")
            continue
        seen[q] = True
        count += 1
        if count > num_questions:
            break
        f_questions.write(json.dumps(question) + "\n") 
        responses = question["responses"]
        correct = question["correct"]
        for r in responses:
            label = "false"
            if r == correct:
                label = "true"
            qa.append(f"- Q: {q} A: {r}")
            labels.append(label)

def write_keys(d, f):
    for key in d:
        f.write(f"{key}\n")

with open("assertions.mc.good.txt", "w") as f:
    write_keys(qa, f)
with open("labels.mc.good.txt", "w") as f:
    write_keys(labels, f)
f_questions.close()
