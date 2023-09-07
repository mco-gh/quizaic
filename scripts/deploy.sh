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

. scripts/env.sh deploy

if [ "$1" = "ui" ]
then
    cd ui
    export VERSION=$(cat version)
    export TAG="${REGION}-docker.pkg.dev/${PROJECT_ID}/${APP}/ui:v${VERSION}"
    gcloud builds submit . --tag=$TAG
    gcloud run deploy ui --region ${REGION} --image=${TAG} --allow-unauthenticated
    cd -
elif [ "$1" = "api" ]
then
    cd api
    export VERSION=$(cat version)
    export TAG="${REGION}-docker.pkg.dev/${PROJECT_ID}/${APP}/content_api:v${VERSION}"
    gcloud builds submit . --tag=$TAG
    gcloud run deploy api --region ${REGION} --image=${TAG} --update-env-vars "${CLOUD_RUN_VARS}" --allow-unauthenticated
    cd -
else
    echo "Usage: $USAGE"
    exit 1
fi
