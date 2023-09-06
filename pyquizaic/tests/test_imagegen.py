import json
import pytest

from generators.image.imagegen import ImageGen

# Change to your own project for tests to pass
PROJECT_ID = "quizrd-prod-atamel"
BUCKET_NAME = PROJECT_ID + "-images"

def test_generate_image():
    images = ImageGen.generate_images("Cyprus")
    assert(images[0] is not None)


def test_generate_and_upload_image():
    file_url = ImageGen.generate_and_upload_image("Cyprus", "image_test.png", BUCKET_NAME)
    print(f'file_url: {file_url}')
    assert (file_url is not None)
