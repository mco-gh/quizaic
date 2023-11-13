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

import hashlib
import json
import os
import random
import sys

sys.path.append("..")
from google.cloud import firestore
from generators.quiz.quizgenfactory import QuizgenFactory
from generators.image.imagegen import ImageGen

topic = "Baseball History"

gen = QuizgenFactory.get_gen("gpt")
quiz = gen.gen_quiz(topic, 3, 4, difficulty="easy")
print("\nEASY\n")
print(json.dumps(quiz, indent=4))
quiz = gen.gen_quiz(topic, 3, 4, difficulty="medium")
print("\nMEDIUM\n")
print(json.dumps(quiz, indent=4))
quiz = gen.gen_quiz(topic, 3, 4, difficulty="hard")
print("\nHARD\n")
print(json.dumps(quiz, indent=4))
