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
    TAG="${REGION}-docker.pkg.dev/${PROJECT_ID}/quizrd/website:v${VERSION}"
    docker build -f website/Dockerfile -t ${TAG} .
    docker push ${TAG}
    gcloud run deploy website --region ${REGION} --image=${TAG} \
        --set-env-vars "${SITE_VARS}" --allow-unauthenticated
elif [ "$1" = "content-api" ]
then
    . scripts/env.sh
    cd content-api
    VERSION=$(cat version)
    TAG="${REGION}-docker.pkg.dev/${PROJECT_ID}/quizrd/content_api:v${VERSION}"
    docker build -t ${TAG} .
    docker push ${TAG}
    gcloud run deploy content-api --region ${REGION} --image=${TAG} --allow-unauthenticated
    cd -
else
    echo "Usage: $USAGE"
    exit 1
fi
