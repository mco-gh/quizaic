# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os


####################################################
# TODO(developer): set these environment variables #
####################################################
PROJECT_ID=os.getenv("PROJECT_ID")
REGION=os.getenv("REGION")
CLIENT_ID = os.getenv("CLIENT_ID")
CLIENT_SECRET = os.getenv("CLIENT_SECRET")
REDIRECT_URI = os.getenv("REDIRECT_URI")
API_URL = os.getenv("API_URL")
SESSION_BUCKET = os.getenv("SESSION_BUCKET")
IMAGES_BUCKET=os.getenv("IMAGES_BUCKET")
