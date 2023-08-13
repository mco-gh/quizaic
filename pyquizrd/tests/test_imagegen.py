import json
import pytest

from generators.image.imagegen import ImageGen

# Change to your own project for tests to pass
PROJECT_ID = "quizrd-prod-atamel"
REGION = "us-central1"
BUCKET_NAME = PROJECT_ID + "-images"


def get_gen():
    config = {"project_id": PROJECT_ID,
              "region": REGION}
    return ImageGen(config)


def test_generate_image():
    gen = get_gen()
    image = gen.generate_image("Cyprus")
    assert(image is not None)


def test_generate_and_upload_image():
    gen = get_gen()
    file_url = gen.generate_and_upload_image("Cyprus", "image_test.png", BUCKET_NAME)
    print(f'file_url: {file_url}')
    assert (file_url is not None)
