set -x
if [ "$REDIRECT_URI" = "" ]
then
  . ../scripts/env.sh
fi

if [ "$METHOD" = "" ]
then
  export METHOD=GET
fi

curl -X $METHOD -s $EMBLEM_API_URL/$1 -H "Authorization: Bearer $ID_TOKEN"
