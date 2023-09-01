#
# run.sh <component>
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
    . ~/keys.sh
    export API_URL=http://localhost:8081
    export REDIRECT_URI=http://localhost:8080/callback
    cd ui 
    python3 -m pip install -r requirements.txt
    FLASK_APP=app.py flask run --port 8080 --debugger --reload
    cd -
elif [ "$1" = "api" ]
then
    . scripts/env.sh
    cd api
    python3 -m pip install -r requirements.txt
    FLASK_APP=main.py flask run --port 8081 --debugger --reload
    cd -
else
    echo "Usage: $USAGE"
    exit 1
fi
