
. scripts/env.sh

echo -e "=====\nEnabling cloud services...\n=====\n"
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable firestore.googleapis.com
DBNAME="projects/$PROJECT_ID/databases/(default)"
gcloud firestore databases list | grep $DBNAME >/dev/null 2>&1
if [ "$?" != "0" ]
then
    gcloud firestore databases create --location nam5
fi
gsutil mb gs://${PROJECT_ID}-sessions

echo -e "=====\nSetting environment...\n=====\n"
. scripts/env.sh

echo -e "=====\nResetting firestore database...\n=====\n"
cd content-api/data
python3 seed_database.py unseed
python3 seed_database.py seed marcacohen@gmail.com
cd -

echo -e "=====\nGenerating content API...\n=====\n"
npm install @openapitools/openapi-generator-cli -g
scripts/regen_api.sh

echo -e "=====\nBuilding and deploying content API...\n=====\n"
cd content-api
./deploy.sh
cd -

echo -e "=====\nBuilding and deploying website...\n=====\n"
cd website
pip install -r requirements.txt
./deploy.sh
cd -
