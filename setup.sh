export PROJECT_ID=$(gcloud config get-value project)

printf "=====\nUncompressing generator data...\n=====\n"
JEP_FILE="website/gen/jeopardy/pruned_jeopardy.json"
if [ ! -f "$JEP_FILE" ]
then
    uncompress ${JEP_FILE}.Z
fi

printf "=====\nEnabling cloud services...\n=====\n"
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable firestore.googleapis.com
gcloud services enable secretmanager.googleapis.com

DBNAME="projects/$PROJECT_ID/databases/(default)"
gcloud firestore databases list | grep $DBNAME >/dev/null 2>&1
if [ "$?" != "0" ]
then
    gcloud firestore databases create --location nam5
fi
gsutil mb gs://${PROJECT_ID}-sessions

printf "=====\nSetting environment...\n=====\n"
./scripts/env.sh

printf "=====\nResetting firestore database...\n=====\n"
cd content-api/data
python3 seed_database.py unseed
python3 seed_database.py seed marcacohen@gmail.com
cd -

printf "=====\nGenerating content API...\n=====\n"
#npm install @openapitools/openapi-generator-cli -g
./scripts/regen_api.sh

printf "=====\nBuilding and deploying content API...\n=====\n"
cd content-api
./deploy.sh
cd -

printf "=====\nBuilding and deploying website...\n=====\n"
cd website
../scripts/env.sh # reload env to get API_URL from deployed content-apis service
pip install -r requirements.txt
./deploy.sh
cd -
