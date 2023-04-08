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


@quizzes_bp.route("/")
def list_quizzes():
    current_user = None

    if g.session_data:
        current_user = g.session_data.get("email")

    try:
        quizzes = g.api.quizzes_get()
    except Exception as e:
        log(f"Exception when listing quizzes view: {e}", severity="ERROR")
        quizzes = []
    return render_template("home.html", quizzes=quizzes, current_user=current_user)


@quizzes_bp.route("/createQuiz", methods=["GET"])
def new_quiz():
    return render_template("create-quiz.html")


@quizzes_bp.route("/createQuiz", methods=["POST"])
def save_quiz():
    try:
        log(request.form)
        sync = request.form["sync"] == "true"
        anonymous = request.form["anonymous"] == "true"
        difficulty = int(request.form["difficulty"])
        timeLimit = int(request.form["timeLimit"])
        numQuestions = int(request.form["numQuestions"])
        numAnswers = int(request.form["numAnswers"])
        g.api.quizzes_post(
            {
                "name":         request.form["name"],
                "description":  request.form["description"],
                #"topic":        request.form["topic"],
                "imageUrl":     request.form["imageUrl"],
                #"timeLimit":    timeLimit,
                "difficulty":   difficulty,
                "numQuestions": numQuestions,
                "numAnswers":   numAnswers,
                "sync":         sync,
                "anonymous":    anonymous,
                #"freeform":     request.form["freeform"],
                # host | the id of the *host* of this *quiz*
                # playUrl | direct URL for playing this *quiz*
                # pin | pin code for playing this *quiz*
                # randomQ | boolean; whether to randomize question order |"
                # randomA | boolean; whether to randomize answer order |
                # QandA | array of questions, associated answers, and correct answers comprising this *quiz* |
                # active | boolean; whether this *quiz* is currently available to be played |
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


    return render_template("view-quiz.html", quiz=quiz_instance)
