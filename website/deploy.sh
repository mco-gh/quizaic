. ../scripts/env.sh
gcloud builds submit . --tag=gcr.io/$PROJECT_ID/website
gcloud run deploy website --region $REGION --image=gcr.io/$PROJECT_ID/website \
  --set-env-vars "$SITE_VARS" website
