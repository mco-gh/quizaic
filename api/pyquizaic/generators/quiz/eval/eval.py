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

sys.path.append("../../../../")
from pyquizaic.generators.quiz.quizgenfactory import QuizgenFactory

num_questions = 3
num_answers = 4
language = "English"
difficulty = "medium"
gen = QuizgenFactory.get_gen("opentrivia")
eval = QuizgenFactory.get_gen("palm")

prompt = """
In one (and only one) word, are the following assertions true or false?

"""
qa = []
labels = []

# Generate QA and labels.
for topic in gen.get_topics():
    quiz = gen.gen_quiz(topic, num_questions, num_answers, difficulty, language)
    for question in quiz:
        q = question["question"]
        responses = question["responses"]
        correct = question["correct"] 
        for r in responses:
            label = "false"
            if r == correct:
                label = "true"
            qa.append(f"- Q: {q} A: {r}")
            labels.append(label)

# Shuffle QA and labels.
for i in range(10):
    zipped = list(zip(qa, labels))
    random.shuffle(zipped)
    qa, labels = zip(*zipped)

vertexai.init(project="quizaic", location="us-central1")
parameters = {
    "candidate_count": 1,
    "max_output_tokens": 2048,
    "temperature": 0.0,
    "top_p": 0.0,
    "top_k": 1
}

model = TextGenerationModel.from_pretrained("text-bison")
with open("transcript", "w") as f:
    pass

BATCH_SIZE = 10
valid_grades = []
valid_labels = []
errors = 0

# Generate predictions.
while qa:
    time.sleep(1)
    batch_qa = qa[:BATCH_SIZE]
    batch_labels = labels[:BATCH_SIZE]
    qa = qa[BATCH_SIZE:]
    labels = labels[BATCH_SIZE:]
    p = prompt + "\n".join(batch_qa) + "\n"
    response = model.predict(p)
    new_grades = response.text.replace(",", "").replace(".", "").replace(" ", "").replace("-", "").lower().split()

    error = False
    if len(new_grades) != len(batch_qa):
        print(f"bad prediction: {new_grades=}")
        error = True 
    for i in new_grades:
       if i != "true" and i != "false":
            print(f"bad prediction: {i=}")
            error = True

    with open("transcript", "a") as f:
        f.write(p + "\n")
        f.write(str(response))
        if error:
            f.write("\nERROR!\n")
            errors += 1
        next 

    valid_grades.extend(new_grades)
    valid_labels.extend(batch_labels)

total = 0
wrong = 0
false_p = 0
false_n = 0

if len(valid_grades) != len(valid_labels):
    print(f"{len(valid_grades)=} != {len(valid_labels)=}")
    exit(1)

for i in range(len(valid_grades)):   
    if valid_grades[i] != valid_labels[i]:
        wrong += 1
        if valid_labels[i] == "true":
            false_n += 1
        elif valid_labels[i] == "false":
            false_p += 1
    total += 1

if total <= 0:
    print("no grades found")
    exit(1)

print(f"{total-wrong}/{total}, {100*(total-wrong)/total:.2f}% accurate, {errors=}, {false_n=}, {false_p=}")
