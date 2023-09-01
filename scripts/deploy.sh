#
# deploy.sh <component>
#	- component is one of ui or api
#
USAGE="$0 ui|api"

if [ $# != 1 ]
then
    echo "Usage: $USAGE"
    exit 1
fi

if [ "$1" = "ui" ]
then
    . scripts/env.sh
    VERSION=$(cat ui/version)
    TAG="${REGION}-docker.pkg.dev/${PROJECT_ID}/${APP}/ui:v${VERSION}"
    API_URL=$(gcloud run services describe api --region=$REGION --project $PROJECT_ID --format "value(status.url)")
    # I don't think REDIRECT_URI is needed here. It's setup in configure_auth.sh
    # REDIRECT_URI=$(gcloud run services describe ui --region=$REGION --project $PROJECT_ID --format "value(status.url)")/callback
    gcloud builds submit --config=ui/cloudbuild.yaml --substitutions=_REPOSITORY=${APP},_IMAGE="ui",_VERSION="v${VERSION}"
    gcloud run deploy ui --region ${REGION} --image=${TAG} \
        --update-env-vars "API_URL=$API_URL, SESSION_BUCKET=$SESSION_BUCKET, IMAGES_BUCKET=$IMAGES_BUCKET" \
        --allow-unauthenticated
elif [ "$1" = "api" ]
then
    . scripts/env.sh
    cd api
    VERSION=$(cat version)
    TAG="${REGION}-docker.pkg.dev/${PROJECT_ID}/${APP}/content_api:v${VERSION}"
    gcloud builds submit . --tag=$TAG
    gcloud run deploy api --region ${REGION} --image=${TAG} --allow-unauthenticated
    cd -
else
    echo "Usage: $USAGE"
    exit 1
fi
