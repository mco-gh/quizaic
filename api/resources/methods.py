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
from google.cloud import firestore
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
        "language",
        "qAndA",
        "runCount",
    ],
    "sessions": [
        "quizId",
        "synchronous",
        "timeLimit",
        "anonymous",
        "randomizeQuestions",
        "randomizeAnswers",
        "curQuestion",
        "pin",
        "finalists",
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

    # if resource_kind == "quizzes":
    # hashed_email = get_hashed_email()
    # email = g.get("verified_email", None)
    # print(f"email: {email=}")
    # if auth.user_is_admin(email):
    # print("admin user gets to see all quizzes")
    # results = db.list(resource_kind, resource_fields[resource_kind])
    # else:
    # print("regular user sees public quizzes and their own quizzes")
    # results1 = db.list_matching(resource_kind, resource_fields[resource_kind],
    # "creator", hashed_email)
    # results2 = db.list_matching(resource_kind, resource_fields[resource_kind],
    # "public", True)
    # results = results1 + results2

    else:
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
    email = g.verified_email
    if auth.user_is_admin(email):
        return json.dumps(matching_children), 200, {"Content-Type": "application/json"}

    if resource_kind == "quizzes" and auth.user_created_quiz(hashed_email, id):
        return json.dumps(matching_children), 200, {"Content-Type": "application/json"}

    return json.dumps(matching_children), 200, {"Content-Type": "application/json"}


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

    resource = db.insert(resource_kind, representation, resource_fields[resource_kind])
    id = resource["id"]

    if resource_kind == "sessions":
        print("created a session so created a new results document...")
        results = "results"
        rep = {"hostId": id, "quizId": id, "players": {}}
        db.insert(results, representation, resource_fields[results])

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
        regen_content = representation.get("qAndA", None) == "regen"
        regen_image = representation.get("imageUrl", None) == "regen"

        if regen_content:
            print("generating new quiz content...")
            generator = representation["generator"]
            topic = representation["topic"]
            num_questions = int(representation["numQuestions"])
            # num_answers = int(representation["numAnswers"])
            num_answers = 4
            language = representation["language"]
            difficulty = representation["difficulty"]
            gen = QuizgenFactory.get_gen(generator.lower())
            print(
                f"{type(num_questions)=}, {num_questions=}, {type(num_answers)=}, {num_answers=}"
            )
            quiz = gen.gen_quiz(topic, num_questions, num_answers, difficulty, language)
            print(f"{json}")
            print(json.dumps(quiz, indent=4))
            representation["qAndA"] = json.dumps(quiz)

        if regen_image:
            print("generating a new quiz image...")
            filename = id + ".png"
            file_url = ImageGen.generate_and_upload_image(
                topic, filename, IMAGES_BUCKET
            )
            print(f"file_url: {file_url}")
            representation["imageUrl"] = file_url

    if resource_kind == "results":
        key = next(iter(representation))
        # When a new game starts, the host sends a request to reset the quizId and
        # the players object. Those two cases don't need any special handling.
        val = representation[key]
        parts = key.split(".")
        reporting_results = False
        if len(parts) >= 3 and parts[2] == "results":
            reporting_results = True
            if val >= 1.0:
                score_key = f"{parts[0]}.{parts[1]}.score"
                representation[score_key] = firestore.Increment(val)
        if not reporting_results and key != "quizId" and key != "players":
            # special case for updating a player's results
            player = parts[1]
            if not val:
                # registering a new player for this session so make sure not already there
                resource = db.fetch("results", id, resource_fields[resource_kind])
                if not resource:
                    return f"Can't find requested session {id}", 500, {}
                players = resource["players"]
                if players:
                    if player in players:
                        # player already registered so deny this request
                        return "", 409, {}

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

    if resource_kind == "sessions":
        print("deleted a session so deleting corresponding results document...")
        results = "results"
        db.delete(results, id, resource_fields[results], match_etag)

    return "", status
