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
import os
import random
import re
import sys
import time
import vertexai
from openai import OpenAI
import vertexai
from vertexai.preview.generative_models import (
    GenerationConfig,
    GenerativeModel,
    Image,
    Part,
    HarmCategory,
    HarmBlockThreshold,
)
from vertexai.language_models import TextGenerationModel

sys.path.append("../../../../../")
from pyquizaic.generators.quiz.quizgenfactory import QuizgenFactory

model_versions = {
    "gemini-flash": "gemini-1.5-flash-001",
    "gemini-pro":   "gemini-1.5-pro-001",
    "gemini-ultra": "gemini-1.0-ultra-001",
}

BATCH_SIZE = 10

prompt = f"""

You are an expert fact checker. You will be provided a list of {BATCH_SIZE}
question and answer pairs, and you will decide if each provided anwer is 
by returning a list of the words 'true' or 'false'.

INPUT:
- Q: In which year was the Declaration of Independence signed? A: 1809
- Q: Who was the first US President? A: George Washington
- Q: Who wrote the Gettysburg Address? A: Thomas Jefferson
- Q: What is the capital of France? A: Lyon
- Q: Who invented the Theory of Relativity? A: Albert Einstein
- Q: Who directed Jaws? A: Steven Wright
- Q: Who wrote The Grapes of Wratch? A: John Steinbeck
- Q: Who wrote Oliver Twist? A: William Shakespeare
- Q: Who wrote Hamlet? A: Charles Dickens


RESPONSE:
false
true
false
false
true
true
false
false
false
false

"""

temp = 0.0
top_p = 0.8
top_k = 40

evaluator = sys.argv[1]
generator = sys.argv[2]

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
num_questions = read_file(f"../corpus/{generator}.assertions.txt", assertions)
num_labels = read_file(f"../corpus/{generator}.labels.txt", labels)
assert num_questions == num_labels
#assert num_questions % 4 == 0
questions = [int(i / 4) for i in range(num_questions)]
quizzes = [int(i / 20) for i in range(num_questions)]

# Shuffle assertions and labels.
for i in range(num_shuffles):
    zipped = list(zip(assertions, labels, questions, quizzes))
    random.shuffle(zipped)
    assertions, labels, questions, quizzes = zip(*zipped)

if evaluator == "gpt":
    key = os.getenv("OPENAI_API_KEY")
    client = OpenAI()
    def predict(p):
        completion = client.chat.completions.create(
            model="gpt-4",
            messages=[
                {
                    "role": "assistant",
                    "content": p,
                }
            ],
        )
        return completion.choices[0].message.content
elif evaluator == "palm":
    vertexai.init(project="quizaic", location="us-central1")
    parameters = {
        "candidate_count": 1,
        "max_output_tokens": 2048,
        "temperature": temp,
        "top_p": top_p,
        "top_k": top_k,
    }
    model = TextGenerationModel.from_pretrained("text-bison")
    def predict(p):
        response = model.predict(p)
        return response.text
else:
    if evaluator not in model_versions:
        print(f"unsupported evaluator model {evaluator}")
        exit(1)
    evaluator = model_versions[evaluator]
    vertexai.init(project="quizaic", location="us-central1")
    model = GenerativeModel(evaluator)
    def predict(p):
        responses = model.generate_content(
            p, stream=True, generation_config = {
                "temperature": temp,
                "top_k": top_k,
                "top_p": top_p,
            },
            safety_settings = {
                HarmCategory.HARM_CATEGORY_HATE_SPEECH: HarmBlockThreshold.BLOCK_NONE,
                HarmCategory.HARM_CATEGORY_HARASSMENT: HarmBlockThreshold.BLOCK_NONE,
                HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT: HarmBlockThreshold.BLOCK_NONE,
                HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT: HarmBlockThreshold.BLOCK_NONE,
            }
        )
        result = ""
        for response in responses:
            result += response.text
        return result

valid_grades = []
valid_labels = []
errors = 0
cnt = 0

# Generate predictions.
while assertions:
    cnt += 1
    time.sleep(1)
    batch_assertions = assertions[:BATCH_SIZE]
    batch_labels = labels[:BATCH_SIZE]
    assertions = assertions[BATCH_SIZE:]
    labels = labels[BATCH_SIZE:]
    p = prompt + "\nINPUT:\n" + "\n".join(batch_assertions) + "\n\nRESPONSE:\n"
    response = predict(p)
    print("\n--PROMPT--\n", p, "\n--RESPONSE--\n", response)
    response = re.sub(r'\d', '', response)
    response = (
        response
        .replace("a:", "")
        .replace("A:", "")
        .replace(",", "")
        .replace(".", "")
        .replace(" ", "")
        .replace("-", "")
        .lower()
    )
    grades = response.split()

    while len(grades) > 0 and grades[0] != "true" and grades[0] != "false":
        grades = grades[1:]
    for i in range(len(grades)):
        grades[i].replace("* **true**", "true")
        grades[i].replace("* **false**", "false")
    if len(grades) != len(batch_assertions):
        print(f"{cnt}: bad prediction: {len(grades)=}, {grades=}")
        errors += 1
        continue
    for i in range(len(grades)):
        if grades[i].startswith("true"):
            grades[i] = "true"
        elif grades[i].startswith("false"):
            grades[i] = "false"
    for i in grades:
        if i != "true" and i != "false":
            print(f"{cnt}: bad prediction: {p=}, {response=}, {grades=}")
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
