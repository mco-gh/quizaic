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
        flask run --port 8080 --debugger --reload
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
    echo not implemented yet
else
    echo "Usage: $USAGE"
    exit 1
fi
