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


prompt = """
Generate a multiple choice trivia quiz.

Category: {topic}
Question difficulty level: {difficulty}
Number of questions: {num_questions}
Number or responses per question: {num_answers}
Quiz language: {language}

RULES:

- Accuracy is critical.
- Each question must have exactly one correct response, selected from the responses array.
- Quiz output must be a json array of questions, each of which is an object containing keys "question", "responses", and "correct".

"""

with open(f"prompt.txt", "w") as f_prompt:
    f_prompt.write(prompt)
