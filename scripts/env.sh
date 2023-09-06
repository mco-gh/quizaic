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

export APP=quizaic
export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value project)
export PROJECT_ID=$GOOGLE_CLOUD_PROJECT
export REGION=$(gcloud config get-value compute/region)
export FIRESTORE_DB_LOCATION=nam5
export SESSION_BUCKET=${PROJECT_ID}-sessions
export IMAGES_BUCKET=${PROJECT_ID}-images
