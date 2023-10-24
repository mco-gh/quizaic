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

# ctest.sh - content API test script
#
USAGE="$0 path\n\nexport URL=url-to-api # default is http://localhost:8081\nexport METHOD=http-method     # default is GET\nexport BODY=file # default is no body"

if [ "$#" != 1 ]; then
    echo -e "${USAGE}"
    exit 1
fi
if [ "$REDIRECT_URI" = "" ]; then
    . scripts/env.sh test
fi
if [ "$URL" = "" ]; then
    export URL="localhost:8081"
fi
if [ "$METHOD" = "" ]; then
    export METHOD=GET
fi
if [ "$BODY" != "" ]; then
    export BODY="-H \"Content-Type: application/json\" -d \"$(cat ${BODY})\""
fi

export ID_TOKEN=$(gcloud auth print-identity-token)
curl -X "${METHOD}" -s "${URL}/${1}" -H "Authorization: Bearer $ID_TOKEN" "${BODY}"
