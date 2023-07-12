. ../scripts/env.sh
gcloud config set project $PROJECT_ID
gcloud builds submit . --tag=gcr.io/$PROJECT_ID/website
gcloud run deploy website --region $REGION --image=gcr.io/$PROJECT_ID/website \
  --set-env-vars "$SITE_VARS" --allow-unauthenticated
