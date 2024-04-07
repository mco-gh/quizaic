# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# This script needs to run at the top level:
# ./scripts/setup.sh
#

print_header() {
    dashes=$(printf "%0.s-" {1..55})
    printf "#$dashes\n# $1\n#$dashes\n"
}

. scripts/env.sh test

print_header "Uncompressing generator data."
JEP_FILE="api/pyquizaic/generators/quiz/jeopardy/pruned_jeopardy.json"
if [ ! -f "$JEP_FILE" ]
then
    uncompress ${JEP_FILE}.Z
fi

print_header "Enabling required cloud services."
gcloud services enable \
  aiplatform.googleapis.com \
  cloudbuild.googleapis.com \
  firestore.googleapis.com \
  run.googleapis.com \
  secretmanager.googleapis.com

print_header "Creating Cloud Firestore database."
DBNAME="projects/$PROJECT_ID/databases/(default)"
gcloud firestore databases list | grep $DBNAME >/dev/null 2>&1
if [ "$?" != "0" ]
then
    gcloud firestore databases create --location $FIRESTORE_DB_LOCATION
fi

print_header "Creating Cloud Storage bucket for sessions."
gsutil ls -b gs://${SESSION_BUCKET} >/dev/null 2>&1 || gsutil mb gs://${SESSION_BUCKET}
gsutil acl set public-read gs://${SESSION_BUCKET}

print_header "Creating Cloud Storage bucket for images with acl and cors."
gsutil ls -b gs://${IMAGES_BUCKET} >/dev/null 2>&1 || gsutil mb gs://${IMAGES_BUCKET}
gsutil acl set public-read gs://${IMAGES_BUCKET}
gsutil cors set cors.json gs://${IMAGES_BUCKET}

print_header "Creating Cloud Artifacts repository."
gcloud artifacts repositories create ${APP} --repository-format=docker

print_header "Resetting firestore database."
cd api
python3 -m pip install -r requirements.txt
cd data
python3 -m pip install -r requirements.txt
cd ../..
./scripts/reset_db.sh

print_header "Firebase app configuration."
firebase login
cd ui
dart pub global activate flutterfire_cli
#$HOME/.pub-cache/bin/flutterfire configure
cd -

print_header "Building and deploying api service."
./scripts/deploy.sh api

print_header "Building and deploying foundation ui service."
./scripts/deploy.sh flutter

print_header "Building and deploying ui service."
./scripts/deploy.sh ui
