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

import json
import pytest

from generators.image.imagegen import ImageGen

# Change to your own project for tests to pass
PROJECT_ID = "quizaic-atamel-dev"
BUCKET_NAME = PROJECT_ID + "-images"


def test_generate_image():
    images = ImageGen.generate_images("Cyprus")
    assert images[0] is not None


def test_generate_and_upload_image():
    file_url = ImageGen.generate_and_upload_image(
        "Cyprus", "image_test.png", BUCKET_NAME
    )
    print(f"file_url: {file_url}")
    assert file_url is not None
