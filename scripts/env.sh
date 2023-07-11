export APP=quizrd
export REGION=us-central1
export PROD_PROJECT=quizrd-test
export STAGE_PROJECT=$APP-stage-382117
export OPS_PROJECT=$APP-ops-382117
export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value project)
export PROJECT_ID=$GOOGLE_CLOUD_PROJECT
export SKIP_TRIGGERS=1

export STAGE_CALLBACK_URL=$(gcloud run services describe website --region=$REGION --project $STAGE_PROJECT --format "value(status.url)")/callback
#export PROD_CALLBACK_URL=$(gcloud run services describe website --region=$REGION --project $PROD_PROJECT --format "value(status.url)")/callback
export PROD_CALLBACK_URL=https://quizrd.io/callback
export EMBLEM_CALLBACK_URL=$PROD_CALLBACK_URL

export STAGE_API_URL=$(gcloud run services describe content-api --region=$REGION --project $STAGE_PROJECT --format "value(status.url)")
export PROD_API_URL=$(gcloud run services describe content-api --region=$REGION --project $PROD_PROJECT --format "value(status.url)")
export EMBLEM_API_URL=$PROD_API_URL

export EMBLEM_SESSION_BUCKET=quizrd-prod-382117-sessions
export SITE_VARS="EMBLEM_API_URL=$EMBLEM_API_URL, EMBLEM_SESSION_BUCKET=$EMBLEM_SESSION_BUCKET, REDIRECT_URI=$EMBLEM_CALLBACK_URL"
export ID_TOKEN=$(gcloud auth print-identity-token)
#export REDIRECT_URI=EMBLEM_CALLBACK_URL
export REDIRECT_URI=http://127.0.0.1:8080/callback
