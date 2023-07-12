export APP=quizrd
export REGION=us-central1
export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value project)
export PROJECT_ID=$GOOGLE_CLOUD_PROJECT
export SESSION_BUCKET=${PROJECT_ID}-sessions
