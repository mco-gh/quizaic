if [ "$REDIRECT_URI" = "" ]
then
  . ../scripts/env.sh
fi
curl -s $EMBLEM_API_URL/$1 -H "Authorization: Bearer $ID_TOKEN"
