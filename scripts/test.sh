#
# run.sh <component>
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
    . ~/keys.sh
    export API_URL=http://localhost:8081
    export REDIRECT_URI=http://localhost:8080/callback
    cd website
    python3 -m pip install -r requirements.txt
    FLASK_APP=app.py flask run --port 8080 --debugger --reload
    cd -
elif [ "$1" = "content-api" ]
then
    . scripts/env.sh
    cd content-api
    python3 -m pip install -r requirements.txt
    FLASK_APP=main.py flask run --port 8081 --debugger --reload
    cd -
else
    echo "Usage: $USAGE"
    exit 1
fi

# TODO: add curl testing of content-api
#export URL="localhost:8080"
#if [ "$REDIRECT_URI" = "" ]; then
  #. ../scripts/env.sh
#fi
#if [ "$METHOD" = "" ]; then
  #export METHOD=GET
#fi
#export ID_TOKEN=$(gcloud auth print-identity-token)
#curl -X $METHOD -s $URL/$1 -H "Authorization: Bearer $ID_TOKEN"
