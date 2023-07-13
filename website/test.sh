if [ "$REDIRECT_URI" == "" ]
then
  . ../scripts/env.sh
fi

. ~/keys.sh
export REDIRECT_URI=http://localhost:8080/callback
flask run --port 8080 --debugger --reload
