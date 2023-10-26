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

import hashlib
import json

from main import g, request
from resources import methods
from data import cloud_firestore as db
from utils.logging import log


def user_logged_in(email):
    return email != None


def user_created_quiz(hashed_email, quiz_id):
    if hashed_email is None:
        return False
    quiz = db.fetch("quizzes", quiz_id, ["creator"])
    if quiz and quiz["creator"] == hashed_email:
        return True
    return False


def user_is_admin(email):
    if email is None:
        return False
    matching_admins = db.list_matching(
        "admins", methods.resource_fields["admins"], "email", email
    )
    print(f"user_is_admin: {matching_admins=}")
    return len(matching_admins) > 0


def allowed(operation, resource_kind, representation=None):
    email = g.get("verified_email", None)
    hashed_email = None
    if email:
        hashed_email = hashlib.sha256(email.encode("utf-8")).hexdigest()

    # Check for everything requiring auth

    # Admins (and only admins) can access the admins collection.
    if resource_kind == "admins":
        return user_is_admin(email)

    # Generators are public read but only admins can modify them.
    if resource_kind == "generators":
        # Anyone can read all generator records.
        if operation == "GET":
            return True
        # Must be an admin to create, modify or delete a generator.
        if operation in ["POST", "PATCH", "DELETE"]:
            return user_is_admin(email)
        return False

    # Quizzes can be read by anyone, created by logged in users, and
    # updated or deleted only by the quiz creator (or an admin).
    if resource_kind == "quizzes":
        # Anyone can read all quiz records (even unauthenticated players).
        if operation == "GET":
            return True
        # Must be logged in to create a quiz.
        if operation == "POST":
            return user_logged_in(email)
        # Must be an admin or quiz creator to modify or delete a quiz.
        if operation in ["PATCH", "DELETE"]:
            path_parts = request.path.split("/")
            quiz_id = path_parts[2]
            return user_is_admin(email) or user_created_quiz(hashed_email, quiz_id)
        return False

    if resource_kind == "sessions":
        # Must be logged in to create a session
        if operation in ["GET", "POST"]:
            return user_logged_in(email) or user_is_admin(email)
        # must match hashed email address (or be admin) to update or delete a session
        if operation in ["PATCH", "DELETE"]:
            path_parts = request.path.split("/")
            session_id = path_parts[2]
            return (
                user_logged_in(email) and session_id == hashed_email
            ) or user_is_admin(email)
        return False

    # Only admin or host can create, get, or delete documents in the results collection.
    # Players can update their own results via the patch method.
    if resource_kind == "results":
        if operation in ["POST", "GET", "DELETE"]:
            path_parts = request.path.split("/")
            session_id = path_parts[2]
            return (
                user_logged_in(email) and session_id == hashed_email
            ) or user_is_admin(email)
        if operation == "PATCH":
            return True

    # All other accesses are disallowed. This prevents unanticipated access.
    return False
