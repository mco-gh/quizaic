export APP=quizrd
export REGION=us-central1
export PROD_PROJECT=$APP-prod-382117
export STAGE_PROJECT=$APP-stage-382117
export OPS_PROJECT=$APP-ops-382117
export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value project)
export PROJECT_ID=$GOOGLE_CLOUD_PROJECT
export SKIP_TRIGGERS=1
export EMBLEM_API_URL=$(gcloud run services describe content-api --region=$REGION --project $PROJECT_ID --format "value(status.url)")
export EMBLEM_SESSION_BUCKET=quizrd-prod-382117-sessions/
export SITE_VARS="EMBLEM_API_URL=$EMBLEM_API_URL, EMBLEM_SESSION_BUCKET=$EMBLEM_SESSION_BUCKET"
export ID_TOKEN=$(gcloud auth print-identity-token)
