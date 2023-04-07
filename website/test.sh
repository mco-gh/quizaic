if [ "$REDIRECT_URI" == "" ]
then
  . ../scripts/env.sh
fi
. ~/keys.sh
flask run --port 8080 --debugger --reload
