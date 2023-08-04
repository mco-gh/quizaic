import base64
import json
import google.auth
import google.auth.transport.requests
import os
import requests
import subprocess
import vertexai
from io import BytesIO
from google.cloud import storage
from PIL import Image

PROJECT_ID = "mco-quizrd"
LOCATION = "us-central1"
BUCKET_NAME = "quizrd-img"

AI_PLATFORM_URL = f"https://{LOCATION}-aiplatform.googleapis.com"
IMAGE_MODEL_NAME = "imagegeneration"
PREDICT_URL = f"{AI_PLATFORM_URL}/v1/projects/{PROJECT_ID}/locations/{LOCATION}/publishers/google/models/{IMAGE_MODEL_NAME}:predict"
PROMPT_TEMPLATE= "photorealistic image about {topic}"
NEGATIVE_PROMPT = "blurry"

# Option1
METADATA_URL = "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/identity"
ACCESS_TOKEN_URL = f"{METADATA_URL}?audience={AI_PLATFORM_URL}"

# Option2
#ACCESS_TOKEN_URL = "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token"

class ImageGen:

    def __init__(self):
        pass
        # TODO - I don't think this is needed
        # vertexai.init(project=PROJECT_ID, location=LOCATION)

    def __str__(self):
        return "palm image generator"

    @staticmethod
    def get_access_token():
        # TODO: This currently works from local but not from Cloud Run
        #credentials, your_project_id = google.auth.default(scopes=["https://www.googleapis.com/auth/cloud-platform"])
        credentials, your_project_id = google.auth.default()
        auth_req = google.auth.transport.requests.Request()
        credentials.refresh(auth_req)
        print(f"Returning token: {credentials.token}")
        return credentials.token

        # Remove old code below, once above works for Cloud Run
        if os.getenv("K_SERVICE"):  # TODO - This doesn't work for Cloud Run
            print(f"Getting access token from the metadata service for {CLOUD_RUN_URL}")
            response = requests.get(ACCESS_TOKEN_URL, headers={"Metadata-Flavor": "Google"})
            response.raise_for_status()
            print(f"response.content: {response.content}")
            print(f"response.text: {response.text}")
            access_token = response.text # Option1 ACCESS_TOKEN_URL
            #access_token = response.json()["access_token"] # Option2 ACCESS_TOKEN_URL
        else:
            print("Getting access token with gcloud")
            access_token = subprocess.run(
                ["gcloud", "auth", "print-access-token"],
                capture_output=True,
                text=True,
            ).stdout.strip()

        return access_token

    @staticmethod
    def send_request(headers, data):
        try:
            response = requests.post(PREDICT_URL, headers=headers, data=data)
        except Exception as err:
            print(f"image generation error: {err}")
            raise err
        try:
            print(f"post succeeded: {response.status_code}, {response.reason}, {response.content[:100]}")
        except:
            print("can't print!")

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
                # TODO - I don't think aspectRatio exists?
                #  "aspectRatio": "16:9",
            }
        }

        return headers, json.dumps(data)

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
        access_token = ImageGen.get_access_token()
        headers, data = ImageGen.generate_payload_json(access_token, prompt, **kwargs)
        response = ImageGen.send_request(headers, data)

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
    def save_images(images, folder):
        if not os.path.exists(folder):
            os.makedirs(folder)

        for idx, img in enumerate(images):
            img_path = os.path.join(folder, f"image_{idx}.png")
            img.save(img_path)
            print(f"Saved {img_path}")

    @staticmethod
    def upload_to_gcs(image, file_name, bucket_name=BUCKET_NAME):
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
    def generate_and_upload_image(topic, file_name):
        image = ImageGen.generate_image(topic)
        if image:
            file_url = ImageGen.upload_to_gcs(image, file_name)
            return file_url
        return None


if __name__ == "__main__":

    # images = ImageGen.generate_images("happy dogs", sample_count=4)
    # ImageGen.save_images(images, "images")

    # topic = "American History" # This does not generate any images
    topic = "Cyprus"
    file_name = "image_test.png"

    file_url = ImageGen.generate_and_upload_image(topic, file_name)
    print(f'file_url: {file_url}')


