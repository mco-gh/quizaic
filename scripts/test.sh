#
# test.sh <component>
#	- component is one of ui or api
#
USAGE="$0 ui|api"

if [ $# != 1 ]
then
    echo "Usage: $USAGE"
    exit 1
fi

. scripts/env.sh test

if [ "$1" = "ui" ]
then
    cd ui 
    flutter run -d chrome $FLUTTER_VARS
    cd -
elif [ "$1" = "api" ]
then
    cd api
    . ~/keys.sh
    python3 -m pip install -r requirements.txt
    FLASK_APP=main.py flask run --port 8081 --debugger --reload
    cd -
else
    echo "Usage: $USAGE"
    exit 1
fi
