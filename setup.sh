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
gcloud services enable aiplatform.googleapis.com

printf "=====\nCreating Cloud Firestore database...\n=====\n"
DBNAME="projects/$PROJECT_ID/databases/(default)"
gcloud firestore databases list | grep $DBNAME >/dev/null 2>&1
if [ "$?" != "0" ]
then
    gcloud firestore databases create --location nam5
fi

printf "=====\nCreating Cloud Storage bucket...\n=====\n"
gsutil mb gs://${PROJECT_ID}-sessions

printf "=====\nCreating Cloud Artifacts repo...\n=====\n"
gcloud artifacts repositories create quizrd --location=$REGION --repository-format=docker

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
./run.sh api deploy

printf "=====\nBuilding and deploying website...\n=====\n"
./scripts/env.sh # reload env to get API_URL from deployed content-apis service
./run.sh ui deploy
