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

. scripts/env.sh test

printf "=====\nUncompressing generator data\n=====\n"
JEP_FILE="api/pyquizaic/generators/quiz/jeopardy/pruned_jeopardy.json"
if [ ! -f "$JEP_FILE" ]
then
    uncompress ${JEP_FILE}.Z
fi

printf "=====\nEnabling required cloud services\n=====\n"
gcloud services enable \
  aiplatform.googleapis.com \
  cloudbuild.googleapis.com \
  firestore.googleapis.com \
  run.googleapis.com \
  secretmanager.googleapis.com

printf "=====\nCreating Cloud Firestore database\n=====\n"
DBNAME="projects/$PROJECT_ID/databases/(default)"
gcloud firestore databases list | grep $DBNAME >/dev/null 2>&1
if [ "$?" != "0" ]
then
    gcloud firestore databases create --location $FIRESTORE_DB_LOCATION
fi

printf "=====\nCreating Cloud Storage bucket for sessions\n=====\n"
gsutil mb gs://${SESSION_BUCKET}
gsutil acl set public-read gs://${SESSION_BUCKET}

printf "=====\nCreating Cloud Storage bucket for images with acl and cors\n=====\n"
gsutil mb gs://${IMAGES_BUCKET}
gsutil acl set public-read gs://${IMAGES_BUCKET}
gsutil cors set cors.json gs://${IMAGES_BUCKET}

printf "=====\nCreating Cloud Artifacts repository\n=====\n"
gcloud artifacts repositories create ${APP} --location=$REGION --repository-format=docker

printf "=====\nResetting firestore database\n=====\n"
cd api
python3 -m pip install -r requirements.txt
cd data
python3 -m pip install -r requirements.txt
cd ../..
./scripts/reset_db.sh

printf "=====\nBuilding and deploying api service\n=====\n"
./scripts/deploy.sh api

printf "=====\nBuilding and deploying ui service\n=====\n"
./scripts/deploy.sh ui
