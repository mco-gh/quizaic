#
# deploy.sh <component>
#	- component is one of website or content-api
#
USAGE="$0 website|content-api"

if [ $# != 1 ]
then
    echo "Usage: $USAGE"
    exit 1
fi

if [ "$1" = "website" ]
then
    . scripts/env.sh
    VERSION=$(cat website/version)
    TAG="${REGION}-docker.pkg.dev/${PROJECT_ID}/${APP}/website:v${VERSION}"
    API_URL=$(gcloud run services describe content-api --region=$REGION --project $PROJECT_ID --format "value(status.url)")
    # I don't think REDIRECT_URI is needed here. It's setup in configure_auth.sh
    # REDIRECT_URI=$(gcloud run services describe website --region=$REGION --project $PROJECT_ID --format "value(status.url)")/callback
    gcloud builds submit --config=website/cloudbuild.yaml --substitutions=_REPOSITORY=${APP},_IMAGE="website",_VERSION="v${VERSION}"
    gcloud run deploy website --region ${REGION} --image=${TAG} \
        --update-env-vars "API_URL=$API_URL, SESSION_BUCKET=$SESSION_BUCKET, IMAGES_BUCKET=$IMAGES_BUCKET" \
        --allow-unauthenticated
elif [ "$1" = "content-api" ]
then
    . scripts/env.sh
    cd content-api
    VERSION=$(cat version)
    TAG="${REGION}-docker.pkg.dev/${PROJECT_ID}/${APP}/content_api:v${VERSION}"
    gcloud builds submit . --tag=$TAG
    gcloud run deploy content-api --region ${REGION} --image=${TAG} --allow-unauthenticated
    cd -
else
    echo "Usage: $USAGE"
    exit 1
fi
