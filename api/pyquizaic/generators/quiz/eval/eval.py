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
import vertexai
from vertexai.language_models import TextGenerationModel

sys.path.append("../../../../")
from pyquizaic.generators.quiz.quizgenfactory import QuizgenFactory

num_questions = 1
num_answers = 4
language = "English"
difficulty = "medium"
gen = QuizgenFactory.get_gen("opentrivia")
eval = QuizgenFactory.get_gen("palm")

prompt = f"""I want you to grade a quiz. I'll give you a sequence of questions and answers and for each pair, I want you to give me a list of the words "true" or "false", based on whether each answer is correct.

"""
q_and_a = []
labels = []

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
            q_and_a.append(f"{q}, {r}")
            labels.append(label)

for i in range(3):
    zipped = list(zip(q_and_a, labels))
    random.shuffle(zipped)
    q_and_a, labels = zip(*zipped)
prompt = prompt + "\n".join(q_and_a)

vertexai.init(project="quizaic", location="us-central1")
parameters = {
    "candidate_count": 1,
    "max_output_tokens": 1024,
    "temperature": 0.0,
    "top_p": 0.8,
    "top_k": 40
}
model = TextGenerationModel.from_pretrained("text-bison")
response = model.predict(prompt)
print(f"{response=}")
grades = response.text.replace(",", "").split()
with open("prompt", "w") as f:
    f.write(prompt)
with open("response", "w") as f:
    f.write(response.text)
total = 0
wrong = 0
for i in range(len(grades)):   
    if (grades[i] != labels[i]):
        wrong += 1
    total += 1

print(f"{wrong} mistakes out of {total} total, {100*(total-wrong)/total}% accurate.")
