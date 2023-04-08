openapi-generator-cli version-manager set 5.2.1
#openapi-generator-cli version-manager set 5.3.0
openapi-generator-cli generate -g python -i content-api/openapi.yaml -o client-libs/python
cd client-libs/python/generated
rm -rf *
cp -r ../openapi_client/* .
cd ../../../website
rm -rf client-libs
cp -r ../client-libs .
pip install -r requirements.txt
pwd
rm ../openapitools.json
openapi-generator-cli version-manager set 5.2.1
