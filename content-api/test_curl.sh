curl http://127.0.0.1:8080/$1 -H "Authorization: Bearer $(gcloud auth print-identity-token)"
