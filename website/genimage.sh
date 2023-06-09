#!/bin/sh

TOPIC=$1
OUTPUT=$2

cat >image-request.json <<!EOF
{
    "instances": [
        {
        "prompt": "photorealistic image about $TOPIC"
        }
    ],
    "parameters": {
        "sampleCount": 1,
        "negativePrompt": "blurry",
        "aspectRatio": "16:9"
    }
}
!EOF

PROJECT_ID=cloud-llm-preview2

curl -s -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/json; charset=utf-8" \
    -d @image-request.json \
    "https://us-central1-aiplatform.googleapis.com/v1/projects/$PROJECT_ID/locations/us-central1/publishers/google/models/imagegeneration:predict" \
    > image-output.json

IMAGE_NUM=0
IMAGE_TYPE=$(cat image-output.json | jq .predictions[$IMAGE_NUM].mimeType)
if [ '"image/png"' = "$IMAGE_TYPE" ] ; then
    cat image-output.json | jq -r .predictions[$IMAGE_NUM].bytesBase64Encoded > t.base64
    base64 -d -i t.base64 -o $OUTPUT.jpg
    gsutil cp $OUTPUT.jpg gs://quizrd-img/$OUTPUT.jpg
    gsutil acl set public-read gs://quizrd-img/$OUTPUT.jpg
else
    echo NO: IMAGE_TYPE=$IMAGE_TYPE
fi
