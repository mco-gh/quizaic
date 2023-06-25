#!/bin/bash

#export PROJECT=cloud-llm-preview2
export PROJECT=quizrd-prod-382117
export REGION=us-central1
export MODEL=imagegeneration
export URL="https://us-central1-aiplatform.googleapis.com"
export URLPATH="/v1/projects/$PROJECT/locations/$REGION/publishers/google/models/$MODEL:predict"

export TOPIC="$1"
export FILE="$(echo $2 | tr ' ' '-')"

if [ "$K_SERVICE" = "" ]
then
    export TOKEN=$(gcloud auth print-access-token)
else
    export TOKEN=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/identity?audience=$URL" -H "Metadata-Flavor: Google")
fi

cat >request-$FILE.json <<!EOF
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

curl -X POST \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json; charset=utf-8" \
    -d @request-$FILE.json \
    "$URL/$URLPATH" \
    > output-$FILE.json

IMAGE_NUM=0
IMAGE_TYPE=$(cat output-$FILE.json | jq .predictions[$IMAGE_NUM].mimeType)
if [ '"image/png"' = "$IMAGE_TYPE" ]
then
    cat output-$FILE.json | jq -r .predictions[$IMAGE_NUM].bytesBase64Encoded > $FILE.base64
    base64 -d -i $FILE.base64 -o $FILE.jpg
    gsutil -q cp -a public-read $FILE.jpg gs://quizrd-img/$FILE.jpg
else
    echo Error: IMAGE_TYPE=$IMAGE_TYPE
fi
rm -f request-$FILE.json output-$FILE.json $FILE.base64 $FILE.jpg
if [ "$IMAGE_TYPE" = "null" ]
then
    exit 1
fi
