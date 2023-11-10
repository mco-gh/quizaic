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
from google.cloud import aiplatform_v1beta1
from vertexai.language_models import TextGenerationModel, TextEmbeddingModel

sys.path.append("../../../../../")
from pyquizaic.generators.quiz.quizgenfactory import QuizgenFactory

gen = QuizgenFactory.get_gen("palm")
model = TextEmbeddingModel.from_pretrained("textembedding-gecko@001")

vertex_ai_client = aiplatform_v1beta1.MatchServiceClient()
quiz = gen.gen_quiz("baseball", 10, 4)
for question in quiz:
    request = aiplatform_v1beta1.FindNeighborsRequest(
        index_endpoint="projects/780573810218/locations/us-central1/indexEndpoints/6195409372936404992",
        deployed_index_id="corpus_mc_good_1699565521918",
    )
    question = json.dumps(question)
    embeddings = model.get_embeddings([question])[0].values
    dp1 = aiplatform_v1beta1.IndexDatapoint(datapoint_id="0", feature_vector=embeddings)
    query = aiplatform_v1beta1.FindNeighborsRequest.Query(datapoint=dp1)
    request.queries.append(query)
    response = vertex_ai_client.find_neighbors(request)
    print(f"{response=}")
