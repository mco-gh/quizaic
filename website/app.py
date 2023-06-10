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

import os

from flask import Flask, current_app
from os import path, walk
from views.errors import errors_bp
from views.auth import auth_bp
from views.robots_txt import robots_txt_bp

from views.quizzes import quizzes_bp
from views.host import host_bp

from middleware import auth, csp

app = Flask(__name__)

app.register_blueprint(errors_bp)
app.register_blueprint(auth_bp)
app.register_blueprint(robots_txt_bp)

app.register_blueprint(quizzes_bp)
app.register_blueprint(host_bp)

# Initialize middleware
auth.init(app)
csp.init(app)


CONFIG_PATH = os.path.join(os.path.dirname(__file__), "config.py")

if os.path.exists(CONFIG_PATH):
    app.config.from_object("config")
else:
    raise Exception("Missing configuration file.")


extra_dirs = ['templates', "views", "static"]
extra_files = extra_dirs[:]
for extra_dir in extra_dirs:
    for dirname, dirs, files in walk(extra_dir):
        for filename in files:
            filename = path.join(dirname, filename)
            if path.isfile(filename):
                extra_files.append(filename)
print(extra_files)

if __name__ == "__main__":
    PORT = int(os.getenv("PORT")) if os.getenv("PORT") else 8080

    # This is used when running locally. Gunicorn is used to run the
    # application on Cloud Run; see "entrypoint" parameter in the Dockerfile.
    app.run(host="127.0.0.1", port=PORT, debug=True, extra_files=extra_files)
