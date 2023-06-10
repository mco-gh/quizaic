#!/bin/sh

TOPIC="$1"
FILENAME=$(echo $2 | tr ' ' '-') 

cat >request-$FILENAME.json <<!EOF
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
    -d @request-$FILENAME.json \
    "https://us-central1-aiplatform.googleapis.com/v1/projects/$PROJECT_ID/locations/us-central1/publishers/google/models/imagegeneration:predict" \
    > output-$FILENAME.json

IMAGE_NUM=0
IMAGE_TYPE=$(cat output-$FILENAME.json | jq .predictions[$IMAGE_NUM].mimeType)
if [ '"image/png"' = "$IMAGE_TYPE" ] ; then
    cat output-$FILENAME.json | jq -r .predictions[$IMAGE_NUM].bytesBase64Encoded > $FILENAME.base64
    base64 -d -i $FILENAME.base64 -o $FILENAME.jpg
    gsutil -q cp -a public-read $FILENAME.jpg gs://quizrd-img/$FILENAME.jpg
else
    echo NO: IMAGE_TYPE=$IMAGE_TYPE
fi
rm -f request-$FILENAME.json output-$FILENAME.json $FILENAME.base64 $FILENAME.jpg
