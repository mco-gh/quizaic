# ctest.sh - content API test script
#
USAGE="$0 path\n\nexport URL=url-to-content-api # default is http://localhost:8080\nexport METHOD=http-method     # default is GET\nexport BODY=file # default is no body"

if [ "$#" != 1 ]; then
    echo -e "${USAGE}"
    exit 1
fi
if [ "$REDIRECT_URI" = "" ]; then
    . ../scripts/env.sh
fi
if [ "$URL" = "" ]; then
    export URL="localhost:8080"
fi
if [ "$METHOD" = "" ]; then
    export METHOD=GET
fi
if [ "$BODY" != "" ]; then
    export BODY="-H \"Content-Type: application/json\" -d \"$(cat ${BODY})\""
fi

export ID_TOKEN=$(gcloud auth print-identity-token)
curl -X "${METHOD}" -s "${URL}/${1}" -H "Authorization: Bearer $ID_TOKEN" "${BODY}"
