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
# test.sh <component>
#	- component is one of ui or api
#
USAGE="$0 ui|api"

if [ $# != 1 ]
then
    echo "Usage: $USAGE"
    exit 1
fi

. scripts/env.sh test

if [ "$1" = "ui" ]
then
    cd ui 
    flutter run -d chrome $FLUTTER_VARS
    cd -
elif [ "$1" = "api" ]
then
    cd api
    . ~/keys.sh
    python3 -m pip install -r requirements.txt
    FLASK_APP=main.py flask run --port 8081 --debugger --reload
    cd -
else
    echo "Usage: $USAGE"
    exit 1
fi
