. ../scripts/env.sh
gcloud builds submit . --tag=gcr.io/$PROJECT_ID/content-api
gcloud run deploy content-api --region $REGION --image=gcr.io/$PROJECT_ID/content-api --allow-unauthenticated
