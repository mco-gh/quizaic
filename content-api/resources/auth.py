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


def user_is_host(email, quiz_id):
    if email is None:
        return False
    if quiz_id == "any":
        matching_hosts = db.list_matching(
            "hosts", methods.resource_fields["hosts"], "email", email
        )
        return len(matching_hosts) > 0
    quiz = db.fetch("quizzes", quiz_id, methods.resource_fields["quizzes"])
    if quiz is None or quiz.get("host") is None:
        return False
    return quiz.get("host") == email


def user_is_player(email, player_id):
    if email is None:
        return False
    if player_id == "any":
        matching_players = db.list_matching(
            "players", methods.resource_fields["players"], "email", email
        )
        return len(matching_players) > 0
    player = db.fetch("players", player_id, methods.resource_fields["players"])
    if player is None or player.get("email") is None:
        return False
    return player.get("email") == email


def allowed(operation, resource_kind, representation=None):
    email = g.get("verified_email", None)

    # legacy requests get carte blanche
    if resource_kind == "approvers" or
       resource_kind == "campaigns" or
       resource_kind == "causes" or
       resource_kind == "donations" or
       resource_kind == "donors":
      return True

    # Check for everything requiring auth and handle

    is_admin = user_is_admin(email)
    is_host = user_is_host(email, "any")
    
    # Admins (and only admins) can do any operation on the admins collection.
    if resource_kind == "admins":
        return is_admin

    if resource_kind == "hosts":
        # Any admin or authenticated user can create a host record for themself
        if operation == "POST":
            host_email = representation.get("email")
            return is_admin or host_email == email
        # A host record can be read, updated, or deleted only by the
        # host associated with that record or an admin.
        if operation in ["GET", "PATCH", "DELETE"]:
            path_parts = request.path.split("/")
            id = path_parts[1]
            return is_admin or user_is_host(email, id)
        return False

    if resource_kind == "players":
        # Any authenticated user can create a player record for themself
        if operation == "POST":
            player_email = representation.get("email")
            return is_admin or player_email == email
        # A player record can be read, updated, or deleted only by the
        # player associated with that record or an admin.
        if operation in ["GET", "PATCH", "DELETE"]:
            path_parts = request.path.split("/")
            id = path_parts[1]
            return is_admin or user_is_player(email, id)
        return False

    if resource_kind == "quizzes":
        # Must be an admin or a host to create a quiz.
        if operation == "POST":
            return is_admin or is_host
        # Must be an admin or the host associated with a quiz
        # to modify, or delete a quiz.
        if operation in ["PATCH", "DELETE"]:
            path_parts = request.path.split("/")
            id = path_parts[1]
            return is_admin or user_is_host(email, id)
        # Anyone can read all quiz records (for unauthenticated players).
        if operation == "GET":
            return True
        return False

    if resource_kind == "generators":
        # Must be an admin to do anything with generators
        return is_admin

    # All other accesses are disallowed. This prevents unanticipated access.
    return False
