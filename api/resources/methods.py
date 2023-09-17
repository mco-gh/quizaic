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

import hashlib
import json
import os
import random

from main import g, request
from data import cloud_firestore as db
from resources import auth, base
from utils.logging import log
from pyquizaic.generators.quiz.quizgenfactory import QuizgenFactory
from pyquizaic.generators.image.imagegen import ImageGen

IMAGES_BUCKET = os.getenv("IMAGES_BUCKET")
# mco: make these an env var
MIN_PIN = 100
MAX_PIN = 999

resource_fields = {
    "admins": ["name", "email"],
    "quizzes": [
        "creator",
        "name",
        "generator",
        "answerFormat",
        "topic",
        "imageUrl",
        "numQuestions",
        "difficulty",
        "qAndA",
        "runCount",
    ],
    "sessions": [
        "me",
        "active",
        "hostId",
        "quizId",
        "synchronous",
        "timeLimit",
        "survey",
        "anonymous",
        "randomizeQuestions",
        "randomizeAnswers",
        "curQuestion",
        "pin",
    ],
    "results": ["hostId", "quizId", "players"],
    "generators": ["name", "answerFormats", "topics"],
}

# get the current logged in user's hashed email addr
def get_hashed_email():
    hashed_email = None
    email = g.verified_email
    if email:
        hashed_email = hashlib.sha256(email.encode("utf-8")).hexdigest()
    return hashed_email

# List all entities of the given resource_kind, if allowed,
def list(resource_kind):
    log(f"Request to list {resource_kind}", severity="INFO")
    if resource_kind not in resource_fields:
        return "Not found", 404

    if not auth.allowed("GET", resource_kind):
        return "Forbidden", 403

    results = db.list(resource_kind, resource_fields[resource_kind])
    return json.dumps(results), 200, {"Content-Type": "application/json"}


def list_subresource(resource_kind, id, subresource_kind):
    if resource_kind not in resource_fields or subresource_kind not in resource_fields:
        return "Not found", 404

    resource = db.fetch(resource_kind, id, resource_fields[resource_kind])
    if resource is None:
        return "Not found", 404

    # Only match subresources that match the resource
    match_field = resource_kind[:-1]  # Chop off the "s" to get the field name

    # e.g, fetch quizzes whose quiz/creator field matches the quiz/creator id
    matching_children = db.list_matching(
        subresource_kind,
        resource_fields[subresource_kind],
        match_field,
        id,  # Value must match parent id
    )

    hashed_email = get_hashed_email()

    if auth.user_is_admin(email):
        return json.dumps(matching_children), 200, {"Content-Type": "application/json"}

    if resource_kind == "quizzes" and auth.user_created_quiz(hashed_email, id):
        return json.dumps(matching_children), 200, {"Content-Type": "application/json"}

    return json.dumps(results), 200, {"Content-Type": "application/json"}


def get(resource_kind, id):
    log(f"Request to get {resource_kind}", severity="INFO")
    if resource_kind not in resource_fields:
        return "Not found", 404, {}

    if resource_kind == "sessions" and id == "me":
        id = get_hashed_email()

    result = db.fetch(resource_kind, id, resource_fields[resource_kind])
    if result is None:
        return "Not found", 404, {}

    return (
        json.dumps(result),
        200,
        {"Content-Type": "application/json", "ETag": base.etag(result)},
    )


def insert(resource_kind, representation):
    if resource_kind not in resource_fields:
        return "Not found", 404

    if not auth.allowed("POST", resource_kind, representation):
        return "Forbidden", 403

    if resource_kind == "quizzes" or resource_kind == "sessions":
        hashed_email = get_hashed_email()
        if resource_kind == "sessions":
            representation["id"] = hashed_email
            representation["hostId"] = hashed_email
        elif resource_kind == "quizzes":
            representation["creator"] = hashed_email

    if resource_kind == "sessions":
        print("inserting a session so generating a random pin...")
        pin = random.randint(MIN_PIN, MAX_PIN)
        representation["pin"] = str(pin)

    if resource_kind == "quizzes":
        print("inserting a quiz so generating a new quiz...")
        generator = representation["generator"]
        topic = representation["topic"]
        num_questions = int(representation["numQuestions"])
        # num_answers = int(representation["numAnswers"])
        num_answers = 4

        gen = QuizgenFactory.get_gen(generator.lower())
        quiz = gen.gen_quiz(topic, num_questions, num_answers)
        print(json.dumps(quiz, indent=4))
        representation["qAndA"] = json.dumps(quiz)

    resource = db.insert(resource_kind, representation, resource_fields[resource_kind])
    id = resource["id"]

    if resource_kind == "quizzes":
        print("inserting a quiz so generating a new image...")
        filename = resource["id"] + ".png"
        file_url = ImageGen.generate_and_upload_image(topic, filename, IMAGES_BUCKET)
        print(f"file_url: {file_url}")
        patch = {"imageUrl": file_url}

        resource, status = db.update(
            resource_kind, id, patch, resource_fields[resource_kind], None
        )

    return (
        json.dumps(resource),
        201,
        {
            "Content-Type": "application/json",
            "ETag": base.etag(resource),
        },
    )


def patch(resource_kind, id, representation):
    if resource_kind not in resource_fields:
        return "Not found", 404

    if not auth.allowed("PATCH", resource_kind, representation):
        return "Forbidden", 403

    match_etag = request.headers.get("If-Match", None)
    if resource_kind == "quizzes":
        print(f"{id=}, {representation=}")
        print(f"patching quiz id {id}")
    #elif resource_kind == "results":
        #if "question" in representation:
            # single response so need to insert it into the response array
            #responses = db.fetch(resource_kind, id, resource_fields[resource_kind])
            #question_num = representation["questionNum"]
            #response = representation["response"]
            #responses[question_num] = response

    resource, status = db.update(
        resource_kind, id, representation, resource_fields[resource_kind], match_etag
    )
 

    if resource is None:
        return "", status

    return (
        json.dumps(resource),
        201,
        {
            "Content-Type": "application/json",
            "Location": resource["selfLink"],
            "ETag": base.etag(resource),
        },
    )


def delete(resource_kind, id):
    if resource_kind not in resource_fields:
        return "Not found", 404

    if not auth.allowed("DELETE", resource_kind):
        return "Forbidden", 403

    match_etag = request.headers.get("If-Match", None)
    status = db.delete(resource_kind, id, resource_fields[resource_kind], match_etag)

    return "", status
