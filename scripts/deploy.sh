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
# deploy.sh <component>
#	- component is one of ui or api
#
USAGE="$0 ui|api"

if [ $# != 1 ]
then
    echo "Usage: $USAGE"
    exit 1
fi

. scripts/env.sh deploy

if [ "$1" = "ui" ]
then
    cd ui
    export VERSION=$(cat version)
    export TAG="${REGION}-docker.pkg.dev/${PROJECT_ID}/${APP}/ui:v${VERSION}"
    gcloud builds submit . --tag=$TAG
    gcloud run deploy ui --region ${REGION} --image=${TAG} --allow-unauthenticated
    cd -
elif [ "$1" = "api" ]
then
    cd api
    export VERSION=$(cat version)
    export TAG="${REGION}-docker.pkg.dev/${PROJECT_ID}/${APP}/api:v${VERSION}"
    gcloud builds submit . --tag=$TAG
    gcloud run deploy api --region ${REGION} --image=${TAG} --update-env-vars "${CLOUD_RUN_VARS}" --allow-unauthenticated
    cd -
else
    echo "Usage: $USAGE"
    exit 1
fi
