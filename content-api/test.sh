export URL="localhost:8080"

if [ "$REDIRECT_URI" = "" ]
then
  . ../scripts/env.sh
fi

if [ "$METHOD" = "" ]
then
  export METHOD=GET
fi

export ID_TOKEN=$(gcloud auth print-identity-token)
curl -X $METHOD -s $URL/$1 -H "Authorization: Bearer $ID_TOKEN"
