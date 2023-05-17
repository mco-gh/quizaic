. ../scripts/env.sh
export REPO=gcr.io
export PROJECT_ID=$PROD_PROJECT
export SERVICE=flutterapp
export TAG=$REPO/$PROJECT_ID/$SERVICE
gcloud config set project $PROJECT_ID
gcloud builds submit . --tag=$TAG
gcloud run deploy $SERVICE --region $REGION --image=$TAG \
  --set-env-vars "$SITE_VARS" --allow-unauthenticated
