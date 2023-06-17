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
from resources import methods
from data import cloud_firestore as db


def user_is_admin(email):
    if email is None:
        return False
    matching_admins = db.list_matching(
        "admins", methods.resource_fields["admins"], "email", email
    )
    return len(matching_admins) > 0


def allowed(operation, resource_kind, representation=None):
    email = g.get("verified_email", None)

    # Check for everything requiring auth and handle

    is_admin = user_is_admin(email)
    is_host = user_is_host(email, "any")

    # Admins (and only admins) can do any operation on the admins collection.
    if resource_kind == "admins":
        return is_admin

    if resource_kind == "quizzes":
        # Must be an admin or a host to create a quiz.
        if operation == "POST":
            return is_admin or is_host
        # Must be an admin or the host associated with a quiz
        # to modify, or delete a quiz.
        if operation in ["PATCH", "DELETE"]:
            path_parts = request.path.split("/")
            id = path_parts[1]
            return is_admin or user_created_quiz(email, id)
        # Anyone can read all quiz records (even unauthenticated players).
        if operation == "GET":
            return True
        return False

    if resource_kind == "results":
        # Must be an admin or quiz host to do anything with results.
        # Posting results by a player for a given quiz is done
        # directly from the web client to firestore.
        if operation in ["POST", "PATCH", "GET", "DELETE"]:
            path_parts = request.path.split("/")
            id = path_parts[1]
            return is_admin or user_is_host(email, id)
        return False

    if resource_kind == "generators":
        # Must be an admin to do anything with generators
        return is_admin

    # All other accesses are disallowed. This prevents unanticipated access.
    return False
