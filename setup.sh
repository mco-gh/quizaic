echo "=====\nEnabling cloud services...=====\n"
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable firestore.googleapis.com
gcloud firestore databases create --location nam3

echo "=====\nSetting environment...=====\n"
. scripts/env.sh

echo "=====\nResetting firestore database...=====\n"
cd content-api/data
python3 seed_database.py unseed
python3 seed_database.py seed marcacohen@gmail.com
cd -

echo "=====\nGenerating content API...=====\n"
npm install @openapitools/openapi-generator-cli -g
scripts/regen_api.sh

echo "=====\nBuilding and deploying content API...=====\n"
cd content-api
./deploy.sh
cd -

echo "=====\nBuilding and deploying website...=====\n"
cd website
pip install -r requirements.txt
./deploy.sh
cd -
