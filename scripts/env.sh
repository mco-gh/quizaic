# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
USAGE="\n
Project level environment variable settings.\n\n
Usage: <path-to-project-root>/scripts/env.sh test|deploy\n\n
DEPENDENCY: You are expected to have set your account, project, and region via:\n \n
\t- gcloud config set account <your-account>\n
\t- gcloud config set project <your-project>\n
\t- gcloud config set compute/region <your-region>\n
"

export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value project)

# Config settings for the api service.
export PROJECT_ID=$GOOGLE_CLOUD_PROJECT
export REGION=$(gcloud config get-value compute/region)
export SESSION_BUCKET=${PROJECT_ID}-sessions
export PYTHONPATH=.:${PYTHONPATH}

# Config settings for the ui service.
export APP=quizaic
export FIRESTORE_DB_LOCATION=nam5
export IMAGES_BUCKET=${PROJECT_ID}-images

# Mete: setup.sh and configure_auth.sh calls env.sh without any args,
# so this is not going to work
# Environment specific settings.
if [ "$#" != "1" ]
then
    echo -e $USAGE
    exit 1
elif [ "$1" = "test" ]
then
    export API_URL=http://localhost:8081
    export REDIRECT_URI=http://localhost:8080/callback
elif [ "$1" = "deploy" ]
then
    export API_URL=https://api-co24gukjmq-uc.a.run.app
    export REDIRECT_URI=https://api-co24gukjmq-uc.a.run.app/callback
else
    echo -e $USAGE
    exit 1
fi

export CLOUD_RUN_VARS="PROJECT_ID=${PROJECT_ID},REGION=${REGION},SESSION_BUCKET=${SESSION_BUCKET},IMAGES_BUCKET=${IMAGES_BUCKET},PYTHONPATH=.:${PYTHONPATH}"
export FLUTTER_VARS="--dart-define=API_URL=$API_URL --dart-define=REDIRECT_URI=$REDIRECT_URI"
