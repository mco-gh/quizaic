# Copyright 2021 Google LLC
#
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

from main import g, request
from data import cloud_firestore as db
from resources import auth, base
from utils.logging import log


resource_fields = {
    "admins": ["name", "email"],
    "quizzes": [
        "curQuestion",
        "creator",
        "pin",
        "playUrl",
        "name",
        "description",
        "generator",
        "topicFormat",
        "answerFormat",
        "topic",
        "imageUrl",
        "numQuestions",
        "numAnswers",
        "timeLimit",
        "difficulty",
        "temperature",
        "sync",
        "anon",
        "randomQ",
        "randomA",
        "survey",
        "QandA",
        "runCount",
        "active",
        "results",
    ],
    "results": ["quiz", "player", "answers"],
    "generators": ["name"],
}


# List all entities of the given resource_kind, if allowed,
def list(resource_kind):
    log(f"Request to list {resource_kind}", severity="INFO")
    if resource_kind not in resource_fields:
        return "Not found", 404

    if not auth.allowed("GET", resource_kind):
        return "Forbidden", 403

    # Anyone can list quizzes and generators.
    if resource_kind in ["quizzes", "generators"]:
        results = db.list(resource_kind, resource_fields[resource_kind])

    # Only admins can list admins and results.
    elif resource_kind in ["admins", "results"]:
        if auth.user_is_admin(g.verified_email):
            # Must be an admin to list admins or results.
            results = db.list(resource_kind, resource_fields[resource_kind])
    else:
        return "Forbidden", 403

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

    email = g.verified_email

    if auth.user_is_admin(email):
        return json.dumps(matching_children), 200, {"Content-Type": "application/json"}

    if resource_kind == "quizzes" and auth.user_is_creator(email, id):
        return json.dumps(matching_children), 200, {"Content-Type": "application/json"}

    #matching_donors = db.list_matching(
        #"donors", resource_fields["donors"], "email", email
    #)
    #matching_donor_ids = set([donor["id"] for donor in matching_donors])
    #results = [
        #item for item in matching_children if item["donor"] in matching_donor_ids
    #]

    return json.dumps(results), 200, {"Content-Type": "application/json"}


def get(resource_kind, id):
    log(f"Request to get {resource_kind}", severity="INFO")
    if resource_kind not in resource_fields:
        return "Not found", 404, {}

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

    resource = db.insert(
        resource_kind, representation, resource_fields[resource_kind]
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

    match_etag = request.headers.get("If-Match", None)
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

    match_etag = request.headers.get("If-Match", None)
    status = db.delete(resource_kind, id, resource_fields[resource_kind], match_etag)

    return "", status
