import os
from io import BytesIO
from google.cloud import storage
from vertexai.preview.vision_models import ImageGenerationModel

PROJECT_ID = os.getenv("PROJECT_ID")
PROMPT_TEMPLATE= "photorealistic image about {topic}"
NEGATIVE_PROMPT = "blurry"

class ImageGen:

    def __init__(self):
        pass

    def __str__(self):
        return "Google Cloud image generator"

    @staticmethod
    def generate_images(topic, number_of_images=1):
        prompt = PROMPT_TEMPLATE.format(topic=topic)
        print(f'Generating {number_of_images} image(s) with prompt: {prompt}')

        model = ImageGenerationModel.from_pretrained("imagegeneration")
        images = model.generate_images(
            prompt=prompt,
            number_of_images=number_of_images,
            negative_prompt=NEGATIVE_PROMPT,
        )
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
    def upload_to_gcs(image, file_name, bucket_name):
        client = storage.Client()
        bucket = client.bucket(bucket_name)
        blob = bucket.blob(file_name)

        bytes_io = BytesIO()
        image._pil_image.save(bytes_io, format='PNG')
        blob.upload_from_file(bytes_io, rewind=True, content_type="image/png")

        blob.make_public()
        file_url = blob.public_url
        print(f"Uploaded file: {file_name} to bucket: {bucket_name} with file url: {file_url}")
        return file_url

    @staticmethod
    def generate_and_upload_image(topic, file_name, bucket_name):
        images = ImageGen.generate_images(topic)

        if images[0]:
            print(f"image generated, {PROJECT_ID=}, {bucket_name=}")
            file_url = ImageGen.upload_to_gcs(images[0], file_name, bucket_name)
            return file_url
        return None


if __name__ == "__main__":
    topic = "Cyprus"

    # images = ImageGen.generate_images(topic, number_of_images=2)
    # ImageGen.save_images(images, "images")

    PROJECT_ID = "quizrd-prod-atamel"
    BUCKET_NAME = PROJECT_ID + "-images"
    file_name = "image_test2.png"
    file_url = ImageGen.generate_and_upload_image(topic, file_name, BUCKET_NAME)
    print(f'file_url: {file_url}')


