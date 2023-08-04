#
# run.sh <component> <operation>
#	- component is one of ui (quizrd website) or api (quizrd backend)
#	- operation is one of test (run locally) or deploy (push to Cloud Run)
#
USAGE="$0 ui|api test|deploy"

if [ $# != 2 ]
then
    echo "Usage: $USAGE"
    exit 1
fi


if [ "$1" = "ui" ]
then
    if [ "$2" = "test" ]
    then
        . scripts/env.sh
        . ~/keys.sh
        export REDIRECT_URI=http://localhost:8080/callback
        cd website
        FLASK_APP=app.py flask run --port 8080 --debugger --reload
        cd -
    elif [ "$2" = "deploy" ]
    then
        . scripts/env.sh
        VERSION=$(cat website/version)
	TAG="${REGION}-docker.pkg.dev/${PROJECT_ID}/quizrd/website:v${VERSION}"
        docker build -f website/Dockerfile -t ${TAG} .
        docker push ${TAG}
        gcloud run deploy website --region ${REGION} --image=${TAG} \
                --set-env-vars "${SITE_VARS}" --allow-unauthenticated
    fi
elif [ "$1" = "api" ]
then
    if [ "$2" = "test" ]
    then
        . scripts/env.sh
        . ~/keys.sh
        cd content-api
        FLASK_APP=main.py flask run --port 8080 --debugger --reload
        cd -
    elif [ "$2" = "deploy" ]
    then
        . scripts/env.sh
        cd content-api
        VERSION=$(cat version)
	TAG="${REGION}-docker.pkg.dev/${PROJECT_ID}/quizrd/content_api:v${VERSION}"
        docker build -t ${TAG} .
        docker push ${TAG}
        gcloud run deploy content-api --region ${REGION} --image=${TAG} --allow-unauthenticated
        cd -
    fi
else
    echo "Usage: $USAGE"
    exit 1
fi

# curl testing of content-api
#export URL="localhost:8080"
#if [ "$REDIRECT_URI" = "" ]; then
  #. ../scripts/env.sh
#fi
#if [ "$METHOD" = "" ]; then
  #export METHOD=GET
#fi
#export ID_TOKEN=$(gcloud auth print-identity-token)
#curl -X $METHOD -s $URL/$1 -H "Authorization: Bearer $ID_TOKEN"
