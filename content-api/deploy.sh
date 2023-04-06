. ../scripts/env.sh
gcloud builds submit . --tag=gcr.io/$PROJECT_ID/content-api
gcloud run deploy --image=gcr.io/$PROJECT_ID/content-api
