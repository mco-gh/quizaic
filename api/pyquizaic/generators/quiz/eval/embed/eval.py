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
from vertexai.language_models import TextGenerationModel, TextEmbeddingModel

ENDPOINT_ID = "opentrivia_1699634994173"
ENDPOINT_URL = "175029987.us-central1-780573810218.vdb.vertexai.goog"
ENDPOINT_PATH = "projects/780573810218/locations/us-central1/indexEndpoints/3542789192415182848"

sys.path.append("../../../../../")
from pyquizaic.generators.quiz.quizgenfactory import QuizgenFactory

gen = QuizgenFactory.get_gen("palm")
model = TextEmbeddingModel.from_pretrained("textembedding-gecko@001")

client_options = {
    "api_endpoint": ENDPOINT_URL
}
vertex_ai_client = aiplatform_v1.MatchServiceClient(client_options=client_options)
request = aiplatform_v1.FindNeighborsRequest(
    index_endpoint=ENDPOINT_PATH,
    deployed_index_id=ENDPOINT_ID,
)

#quiz = gen.gen_quiz("baseball", 10, 4)
count = 0
quiz = [
"""{"question": "What is the name of the team that plays in the stadium known as 'The Friendly Confines'?", "responses": ["Chicago Cubs", "St. Louis Cardinals", "Chicago White Sox", "Pittsburgh Pirates"], "correct": "Pittsburgh"}"""
]
for question in quiz:
    if count > 0:
        break
    #question = json.dumps(question)
    print(question)

    embeddings = model.get_embeddings([question])[0].values
    dp1 = aiplatform_v1.IndexDatapoint(datapoint_id="0", feature_vector=embeddings)
    query = aiplatform_v1.FindNeighborsRequest.Query(datapoint=dp1)
    request.queries.append(query)
    response = vertex_ai_client.find_neighbors(request)
    count += 1

    t = 0
    for _, n in enumerate(response.nearest_neighbors):
        for _, neighbor in enumerate(n.neighbors): 
            t += neighbor.distance
    print(f"avg distance = {t/10}")
