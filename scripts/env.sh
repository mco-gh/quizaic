#
# Project level environment variable settings. These may be reused in other scripts by
# running ". <path-to-project-root>/scripts/env.sh".
#
# DEPENDENCY: You are expected to have set your account, project, and region via:
#
#     - gcloud config set account <your-account>
#     - gcloud config set project <your-project>
#     - gcloud config set compute/region <your-region>
#

export APP=quizrd
export REGION=$(gcloud config get-value compute/region)
export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value project)
export PROJECT_ID=$GOOGLE_CLOUD_PROJECT
export SESSION_BUCKET=${PROJECT_ID}-sessions

# This line auto-detects the redirect URI for the quizrd content-api Cloud Run service.
export API_URL=$(gcloud run services describe content-api --region=$REGION --project $PROJECT_ID --format "value(status.url)")

# This line auto-detects the redirect URI for the quizrd website Cloud Run service,
# but is now superceded by the next setting, which uses the quizrd app's domain name.
#export REDIRECT_URI=$(gcloud run services describe website --region=$REGION --project $PROJECT_ID --format "value(status.url)")/callback
export REDIRECT_URI=https://quizrd.io/callback

# Variable settings passed into the website docker container when deploying to Cloud Run.
export SITE_VARS="API_URL=$API_URL, SESSION_BUCKET=$SESSION_BUCKET, REDIRECT_URI=$REDIRECT_URI"
