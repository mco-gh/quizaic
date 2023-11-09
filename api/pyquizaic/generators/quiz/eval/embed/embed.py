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
from vertexai.language_models import TextEmbeddingModel

sys.path.append("../../../../../")
from pyquizaic.generators.quiz.quizgenfactory import QuizgenFactory

model = TextEmbeddingModel.from_pretrained("textembedding-gecko@001")
vertexai.init(project="quizaic", location="us-central1")

def text_embedding(li):
    """Text embedding with a Large Language Model."""
    vectors = []
    embeddings = model.get_embeddings(li)
    for embedding in embeddings:
        vector = embedding.values
        vectors.append(vector)
    return vectors

questions = []

def read_file(filename, li):
    count = 0
    with open(filename, "r") as f:
        for line in f:
            line = line.strip()
            li.append(line)
            count += 1
    return count

# Read assertions and labels.
num_questions = read_file("../corpus/questions.mc.good.txt", questions)

count = 0
with open("embed.corpus.mc.txt", "w") as f_embed:
    for question in questions:
        count += 1
        vecs = text_embedding([question])
        f_embed.write(f"{vecs}\n") 
