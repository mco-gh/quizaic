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

eval = QuizgenFactory.get_gen("palm")

prompt = """
In one (and only one) word, are the following assertions true or false?

"""

num_shuffles = 10
assertions = []
labels = []
questions = []
quizzes = []


def read_file(filename, li):
    count = 0
    with open(filename, "r") as f:
        for line in f:
            line = line.strip()
            li.append(line)
            count += 1
    return count


# Read assertions and labels.
num_questions = read_file("../corpus/opentrivia.assertions.txt", assertions)
num_labels = read_file("../corpus/opentrivia.labels.txt", labels)
assert num_questions == num_labels
assert num_questions % 4 == 0
questions = [int(i / 4) for i in range(num_questions)]
quizzes = [int(i / 20) for i in range(num_questions)]

# Shuffle assertions and labels.
for i in range(num_shuffles):
    zipped = list(zip(assertions, labels, questions, quizzes))
    random.shuffle(zipped)
    assertions, labels, questions, quizzes = zip(*zipped)

vertexai.init(project="quizaic", location="us-central1")
parameters = {
    "candidate_count": 1,
    "max_output_tokens": 2048,
    "temperature": 0.0,
    "top_p": 0.0,
    "top_k": 1,
}

model = TextGenerationModel.from_pretrained("text-bison")

BATCH_SIZE = 10
valid_grades = []
valid_labels = []
errors = 0

with open("transcript", "w") as f:
    pass

# Generate predictions.
while assertions:
    time.sleep(1)
    batch_assertions = assertions[:BATCH_SIZE]
    batch_labels = labels[:BATCH_SIZE]
    assertions = assertions[BATCH_SIZE:]
    labels = labels[BATCH_SIZE:]
    p = prompt + "\n".join(batch_assertions) + "\n"
    response = model.predict(p)
    grades = (
        response.text.replace(",", "")
        .replace(".", "")
        .replace(" ", "")
        .replace("-", "")
        .lower()
        .split()
    )

    error = False
    if len(grades) != len(batch_assertions):
        print(f"bad prediction: {grades=}")
        error = True
    for i in grades:
        if i != "true" and i != "false":
            print(f"bad prediction: {i=}")
            error = True

    with open("transcript", "a") as f:
        f.write("\nASSERTIONS:\n" + "\n".join(batch_assertions))
        f.write("\nRESPONSE:\n" + response.text)
        f.write("\nLABELS:\n" + str(batch_labels))
        f.write("\nQUESTIONS:\n" + str(questions))
        if error:
            f.write("\nERROR!\n")
            errors += 1
            continue

    #for i in range(len(grades)):
        #grades[i] = "false" if grades[i] == "true" else "true"

    valid_grades.extend(grades)
    valid_labels.extend(batch_labels)

total = 0
wrong = 0
false_p = 0
false_n = 0

if len(valid_grades) != len(valid_labels):
    print(f"{len(valid_grades)=} != {len(valid_labels)=}")
    exit(1)

question_err = {}
quiz_err = {}
hist = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0}

for i in set(questions):
    question_err[i] = 0
for i in set(quizzes):
    quiz_err[i] = 0

for i in range(len(valid_grades)):
    if valid_grades[i] != valid_labels[i]:
        wrong += 1
        question_err[questions[i]] += 1
        quiz_err[quizzes[i]] += 1
        if valid_labels[i] == "true":
            false_n += 1
        elif valid_labels[i] == "false":
            false_p += 1
    total += 1

if total <= 0:
    print("no grades found")
    exit(1)

print(
    f"assertions: {total-wrong}/{total}, {100*(total-wrong)/total:.2f}% accurate, {errors=}, {false_n=}, {false_p=}"
)

good_questions = 0
for i in question_err:
    hist[question_err[i]] += 1
    if question_err[i] == 0:
        good_questions += 1
    # print(f"Question: {i}, count: {question_err[i]}")

good_quizzes = 0
for i in quiz_err:
    if quiz_err[i] == 0:
        good_quizzes += 1
    # print(f"Quiz: {i}, count: {quiz_err[i]}")

print(
    f"questions: {good_questions}/{len(set(questions))}, {100 * good_questions / len(set(questions)):.2f}%"
)
print(
    f"quizzes: {good_quizzes}/{len(set(quizzes))}, {100 * good_quizzes/ len(set(quizzes)):.2f}%"
)

for i in hist:
    print(f"{hist[i]} questions had {i} errors")
