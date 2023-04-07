# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from flask import Blueprint, g, redirect, request, render_template

from middleware.logging import log

from views.helpers.donors import get_donor_name

from views.helpers.time import convert_utc

from functools import reduce

import re

quizzes_bp = Blueprint("quizzes", __name__, template_folder="templates")


@quizzes_bp.route("/marc")
def list_quizzes():
    current_user = None

    if g.session_data:
        current_user = g.session_data.get("email")

    try:
        quizzes = g.api.quizzes_get()
    except Exception as e:
        log(f"Exception when listing quizzes view: {e}", severity="ERROR")
        quizzes = []
    log(f"quizzes: {quizzes}")
    return render_template("home.html", quizzes=quizzes, current_user=current_user)


@quizzes_bp.route("/createQuiz", methods=["GET"])
def new_quiz():
    try:
        causes = g.api.causes_get()
    except Exception as e:
        log(f"Exception when listing causes: {e}", severity="ERROR")
        causes = []

    return render_template("create-quiz.html", causes=causes)


@quizzes_bp.route("/Quiz", methods=["POST"])
def save_quiz():
    try:
        g.api.quizzes_post(
            {
                "name": request.form["name"],
                "cause": request.form["cause"],
                "imageUrl": request.form["imageUrl"],
                "description": request.form["description"],
                "goal": float(request.form["goal"]),
                "managers": re.split(r"[ ,]+", request.form["managers"]),
                "active": True,
            }
        )
    except Exception as e:
        log(f"Exception when creating a quiz: {e}", severity="ERROR")
        return render_template("errors/403.html"), 403

    return redirect("/")


@quizzes_bp.route("/viewQuiz")
def webapp_view_quiz():
    quiz_id = request.args.get("quiz_id")

    if quiz_id is None:
        log(f"/viewQuiz is missing quiz_id", severity="ERROR")
        return render_template("errors/500.html"), 500

    try:
        quiz_instance = g.api.quizzes_id_get(quiz_id)
        quiz_instance["formattedDateCreated"] = convert_utc(
            quiz_instance.time_created
        )
        quiz_instance["formattedDateUpdated"] = convert_utc(
            quiz_instance.updated
        )
    except Exception as e:
        log(f"Exception when fetching quizzes {quiz_id}: {e}", severity="ERROR")
        return render_template("errors/403.html"), 403

    quiz["donations"] = []
    quiz_instance["raised"] = 0
    quiz_instance["percentComplete"] = 0

    x = """
    try:
        donations = g.api.campaigns_id_donations_get(campaign_instance["id"])
        if len(donations) > 0:
            campaign_instance["donations"] = list(map(get_donor_name, donations))
            raised = reduce(
                lambda t, d: t + int(d["amount"] if d is not None else 0), donations, 0
            )
            campaign_instance["raised"] = raised
            campaign_instance["percentComplete"] = (
                (raised / float(campaign_instance.goal)) * 100
                if raised is not None
                else 0
            )
    except Exception as e:
        log(f"Exception when listing campaign donations: {e}", severity="ERROR")
        return render_template("errors/403.html"), 403
        """

    return render_template("view-quiz.html", quiz=quiz_instance)
