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

import gen
import json
import random
import re
import subprocess

quizzes_bp = Blueprint("quizzes", __name__, template_folder="templates")

@quizzes_bp.route("/")
def list_quizzes():
    current_user = None

    if g.session_data:
        current_user = g.session_data.get("email")

    try:
        quizzes = g.api.quizzes_get()
        log(quizzes[0].results)
    except Exception as e:
        log(f"Exception when listing quizzes view: {e}", severity="ERROR")
        quizzes = []
    return render_template("home.html", quizzes=quizzes, current_user=current_user)


@quizzes_bp.route("/createQuiz", methods=["GET"])
def new_quiz():
    current_user = None

    if g.session_data:
        current_user = g.session_data.get("email")

    empty_quiz = {
        "name": "",
        "description": "",
        "generator": "",
        "topic_format": "",
        "answer_format": "",
        "topic": "",
        "image_url": "",
        "num_questions": "",
        "num_answers": "",
        "time_limit": "",
	"difficulty": "",
	"temperature": "",
        "sync": "",
	"anon": "",
	"random_q": "",
	"random_a": "",
        "qand_a": "",
    };
    gens = gen.Generator.get_gens()
    return render_template("create-quiz.html", op="Create", quiz=empty_quiz, current_user=current_user, gens=gens)

@quizzes_bp.route("/editQuiz", methods=["GET"])
def edit_quiz():
    current_user = None

    if g.session_data:
        current_user = g.session_data.get("email")

    quiz_id = request.args.get("quiz_id")

    if quiz_id is None:
        log(f"/editQuiz is missing quiz_id", severity="ERROR")
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
        log(f"Exception when editing quiz {quiz_id}: {e}", severity="ERROR")
        return render_template("errors/403.html"), 403

    gens = gen.Generator.get_gens()
    qa = json.loads(quiz_instance.qand_a)
    questions = json.dumps(json.loads(quiz_instance.qand_a), indent=2)
    return render_template("create-quiz.html", op="Update", quiz=quiz_instance, questions=questions, qa=qa, current_user=current_user, gens=gens)


@quizzes_bp.route("/deleteQuiz", methods=["GET"])
def delete_quiz():
    try:
        quiz_id = request.args.get("quiz_id")
        if quiz_id is None:
            log(f"/deleteQuiz is missing quiz_id", severity="ERROR")
            return render_template("errors/500.html"), 500
        g.api.quizzes_id_delete(quiz_id)
    except Exception as e:
        log(f"Exception when deleting a quiz: {e}", severity="ERROR")
        return render_template("errors/403.html"), 403
    return redirect("/")

@quizzes_bp.route("/editQuiz", methods=["POST"])
def update_quiz():
    quiz_id = request.args.get("quiz_id")

    if quiz_id is None:
        log(f"/editQuiz is missing quiz_id", severity="ERROR")
        return render_template("errors/500.html"), 500

    try:
        if request.form["topicFormatSelect"] == "freeform":
          topic = request.form["topicText"]
        else:
          topic = request.form["topicSelect"]
        numQuestions = request.form["numQuestions"]
        numAnswers = request.form["numAnswers"]
        difficulty = request.form["difficulty"]
        temperature = request.form["temperature"]
        if request.form["generator"] == "manual" or "regen" not in request.form:
            quiz = request.form["QandA"]
        else:
            generator = gen.Generator(request.form["generator"])
            quiz = generator.gen_quiz(topic, int(numQuestions), int(numAnswers), int(difficulty), float(temperature)) 
        resp = g.api.quizzes_id_patch(quiz_id, 
            {
                "name":         request.form["name"],
                "description":  request.form["description"],
                "generator":    request.form["generator"],
                "topicFormat":  request.form["topicFormatSelect"],
                "answerFormat": request.form["answerFormatSelect"],
                "topic":        topic,
                "imageUrl":     request.form["imageUrl"],
                "numQuestions": numQuestions,
                "numAnswers":   numAnswers,
                "timeLimit":    request.form["timeLimit"],
                "difficulty":   difficulty,
                "temperature":  temperature,
                "sync":         request.form["syncSelect"] == "true",
                "anon":         request.form["anonSelect"] == "true",
                "randomQ":      request.form["randomQSelect"] == "true",
                "randomA":      request.form["randomASelect"] == "true",
                "QandA":        quiz,
            }
        )
    except Exception as e:
        log(f"Exception when updating a quiz: {e}", severity="ERROR")
        return render_template("errors/403.html"), 403

    return redirect("/viewQuiz?quiz_id=" + resp.id)

def gen_image(topic, filename):
    subprocess.call(['sh', 'genimage.sh', topic, filename])
    return f"https://storage.googleapis.com/quizrd-img/{filename}.jpg"

@quizzes_bp.route("/createQuiz", methods=["POST"])
def save_quiz():
    try:
        pin = str(random.randint(1, 9999))
        if request.form["topicFormatSelect"] == "freeform":
          topic = request.form["topicText"]
        else:
          topic = request.form["topicSelect"]
        numQuestions = request.form["numQuestions"]
        numAnswers = request.form["numAnswers"]
        difficulty = request.form["difficulty"]
        temperature = request.form["temperature"]
        if request.form["generator"] == "manual" :
            quiz = request.form["QandA"]
        else:
            generator = gen.Generator(request.form["generator"])
            quiz = generator.gen_quiz(topic, int(numQuestions), int(numAnswers), int(difficulty), float(temperature)) 
        resp = g.api.quizzes_post(
            {
                "pin":          pin,
                "playUrl":      "/" + pin,
                "name":         request.form["name"],
                "description":  request.form["description"],
                "generator":    request.form["generator"],
                "topicFormat":  request.form["topicFormatSelect"],
                "answerFormat": request.form["answerFormatSelect"],
                "topic":        topic,
                "imageUrl":     request.form["imageUrl"],
                "numQuestions": numQuestions,
                "numAnswers":   numAnswers,
                "difficulty":   difficulty,
                "temperature":  temperature,
                "timeLimit":    request.form["timeLimit"],
                "sync":         request.form["syncSelect"] == "true",
                "anon":         request.form["anonSelect"] == "true",
                "randomQ":      request.form["randomQSelect"] == "true",
                "randomA":      request.form["randomASelect"] == "true",
                "QandA":        quiz,
            }
        
        )
        if request.form["imageUrl"] == "/static/logo.png":
            image_url = gen_image(topic, resp.id)
            g.api.quizzes_id_patch(resp.id, { 
                "name":      request.form["name"],
                "imageUrl":  image_url
            })
    except Exception as e:
        log(f"Exception when creating a quiz: {e}", severity="ERROR")
        return render_template("errors/403.html"), 403


    return redirect("/viewQuiz?quiz_id=" + resp.id)


@quizzes_bp.route("/viewQuiz", methods=["GET"])
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

    qa = json.loads(quiz_instance.qand_a)
    questions = json.dumps(json.loads(quiz_instance.qand_a), indent=2)
    return render_template("view-quiz.html", quiz=quiz_instance, qa=qa, questions=questions)

@quizzes_bp.route("/<int:pin>", methods=["GET"])
def start(pin):
    current_user = None
    log(f"pin: {pin}")

    if g.session_data:
        current_user = g.session_data.get("email")

    try:
        quizzes = g.api.quizzes_get()
    except Exception as e:
        log(f"Exception when listing quizzes view: {e}", severity="ERROR")
        quizzes = []

    quiz = None;
    for q in quizzes:
        if q.pin == str(pin):
            quiz = q
            break

    if not quiz:
        log(f"Requested quiz with pin {pin} not found", severity="ERROR")

    return render_template("start.html", quiz=quiz, pin=pin, current_user=current_user)

@quizzes_bp.route("/playQuiz/<int:pin>", methods=["POST"])
def play(pin):
    current_user = None
    log(f"pin: {pin}")

    if g.session_data:
        current_user = g.session_data.get("email")

    try:
        quizzes = g.api.quizzes_get()
    except Exception as e:
        log(f"Exception when listing quizzes view: {e}", severity="ERROR")
        quizzes = []

    quiz = None;
    for q in quizzes:
        if q.pin == str(pin):
            quiz = q
            break
    if not quiz:
        log(f"Requested quiz with pin {pin} not found", severity="ERROR")

    name = request.form['name']
    if not quiz:
        log(f"Player name not provided", severity="ERROR")

    #try:
    #    r = {
    #        "player": name,
    #        "quiz": quiz.id,
    #        "answers": []
    #    }
    #    g.api.results_post(r)
    #    log(quiz)
    #except Exception as e:
    #    log(f"Exception posting new results object: {e}", severity="ERROR")

    return render_template("play.html", quiz=quiz, pin=pin, name=name, current_user=current_user)
