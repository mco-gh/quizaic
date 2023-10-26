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
# ws.sh <action>
#	- build, config, or create
#
USAGE="$0 build|config|create"

if [ $# != 1 ]
then
    echo "Usage: $USAGE"
    exit 1
fi

. scripts/env.sh deploy

cd codelab/ws
if [ "$1" = "build" ]
then
    export VERSION=$(cat version)
    export TAG="${REGION}-docker.pkg.dev/${PROJECT_ID}/${APP}/workstation:v${VERSION}"
    gcloud builds submit . --tag=$TAG
elif [ "$1" = "config" ]
then
    echo "config (TBD)"
elif [ "$1" = "create" ]
then
    echo "create (TBD)"
else
    echo "Usage: $USAGE"
    exit 1
fi
cd -
