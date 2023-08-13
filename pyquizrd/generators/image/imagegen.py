import base64
import json
import google.auth
import google.auth.transport.requests
import os
import requests
from io import BytesIO
from google.cloud import storage
from PIL import Image

IMAGE_MODEL_NAME = "imagegeneration"
PROMPT_TEMPLATE= "photorealistic image about {topic}"
NEGATIVE_PROMPT = "blurry"

REGION = "us-central1" # Hardcoded because AI platform API only works in us-central1 for now
AI_PLATFORM_URL = f"https://{REGION}-aiplatform.googleapis.com"


class ImageGen:

    def __init__(self):
        pass

    def __str__(self):
        return "Google Cloud image generator"

    @staticmethod
    def get_access_token_and_project_id():
        print("Getting access token and project id")
        credentials, project_id = google.auth.default()
        auth_req = google.auth.transport.requests.Request()
        credentials.refresh(auth_req)
        print("Returning token and project id")
        return credentials.token, project_id

    @staticmethod
    def send_request(url, headers, data):
        print(f"Sending request to {url}")
        try:
            response = requests.post(url, headers=headers, data=data)
            print(f"Response status code: {response.status_code}")
        except Exception as err:
            print(f"image generation error: {err}")
            raise err

        if response.status_code != 200:
            raise requests.exceptions.HTTPError(f"Error: {response.status_code} ({response.reason})")
        return response.json()

    @staticmethod
    def generate_payload_json(access_token, prompt, **kwargs):
        negative_prompt = kwargs.get("negative_prompt")
        sample_count = kwargs.get("sample_count")
        sample_image_size = kwargs.get("sample_image_size")
        guidance_scale = kwargs.get("guidance_scale")
        seed = kwargs.get("seed")
        # base_image = kwargs.get("base_image")
        # mask = kwargs.get("mask")
        mode = kwargs.get("mode")

        headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json; charset=utf-8",
        }

        data = {
            "instances": [
                {
                    "prompt": prompt,
                }
            ],
            "parameters": {
                "negativePrompt": negative_prompt,
                "sampleCount": sample_count,
                "sampleImageSize": sample_image_size,
                "seed": seed,
                "guidanceScale": guidance_scale,
                "mode": mode,
                # "aspectRatio": "16:9",
            }
        }

        return headers, json.dumps(data)

    @staticmethod
    def save_images(images, folder):
        if not os.path.exists(folder):
            os.makedirs(folder)

        for idx, img in enumerate(images):
            img_path = os.path.join(folder, f"image_{idx}.png")
            img.save(img_path)
            print(f"Saved {img_path}")

    @staticmethod
    def upload_to_gcs(image, file_name, bucket_name):
        client = storage.Client()
        bucket = client.bucket(bucket_name)
        blob = bucket.blob(file_name)

        bytes_io = BytesIO()
        image.save(bytes_io, format='PNG')
        blob.upload_from_file(bytes_io, rewind=True, content_type="image/png")

        blob.make_public()
        file_url = blob.public_url
        print(f"Uploaded file: {file_name} to bucket: {bucket_name} with file url: {file_url}")
        return file_url

    @staticmethod
    def generate_image(topic):
        prompt = PROMPT_TEMPLATE.format(topic=topic)
        print(f'Generating image with prompt: {prompt}')
        images = ImageGen.generate_images(prompt, negative_prompt=NEGATIVE_PROMPT, sample_count=1)
        if len(images) > 0:
            return images[0]
        return None

    @staticmethod
    def generate_images(prompt, **kwargs):
        access_token, project_id = ImageGen.get_access_token_and_project_id()
        headers, data = ImageGen.generate_payload_json(access_token, prompt, **kwargs)
        predict_url = f"{AI_PLATFORM_URL}/v1/projects/{project_id}/locations/{REGION}/publishers/google/models/{IMAGE_MODEL_NAME}:predict"
        response = ImageGen.send_request(predict_url, headers, data)

        images = []
        if response:
            predictions = response.get("predictions")
            if predictions:
                for prediction in predictions:
                    b64_decoded_string = base64.b64decode(prediction["bytesBase64Encoded"])
                    img = Image.open(BytesIO(b64_decoded_string))
                    images.append(img)
            else:
                print(f"No predictions for prompt: {prompt}")
        return images

    @staticmethod
    def generate_and_upload_image(topic, file_name, bucket_name):
        image = ImageGen.generate_image(topic)
        if image:
            file_url = ImageGen.upload_to_gcs(image, file_name, bucket_name)
            return file_url
        return None


if __name__ == "__main__":

    topic = "Cyprus"
    file_name = "image_test.png"

    PROJECT_ID = "quizrd-prod-atamel"
    REGION = "us-central1"
    BUCKET_NAME = PROJECT_ID + "-images"

    file_url = ImageGen.generate_and_upload_image(topic, file_name, BUCKET_NAME)
    print(f'file_url: {file_url}')


