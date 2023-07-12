export APP=quizrd
export REGION=us-central1
export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value project)
export PROJECT_ID=$GOOGLE_CLOUD_PROJECT
export SESSION_BUCKET=${PROJECT_ID}-sessions
export REDIRECT_URI=https://quizr.io/callback
export API_URL=$(gcloud run services describe content-api --region=$REGION --project $PROD_PROJECT --format "value(status.url)")

export SITE_VARS="API_URL=$API_URL, SESSION_BUCKET=$SESSION_BUCKET, REDIRECT_URI=$REDIRECT_URI"
