#
# This script needs to run at the top level:
# ./scripts/setup.sh
#

. scripts/env.sh test

printf "=====\nUncompressing generator data\n=====\n"
JEP_FILE="ui/gen/jeopardy/pruned_jeopardy.json"
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
cd api/data
python3 -m pip install -r requirements.txt
python3 seed_database.py unseed
python3 seed_database.py seed
cd -

printf "=====\nBuilding and deploying api service\n=====\n"
./scripts/deploy.sh api

printf "=====\nBuilding and deploying ui service\n=====\n"
./scripts/deploy.sh ui
