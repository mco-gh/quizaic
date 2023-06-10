PROJECT=quizrd-prod-382117
ACCOUNT=website-manager@quizrd-prod-382117.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding $PROJECT \
    --member="serviceAccount:$ACCOUNT" \
    --role="roles/aiplatform.user"

gcloud projects add-iam-policy-binding $PROJECT \
    --member="serviceAccount:$ACCOUNT" \
    --role="roles/logging.logWriter"

gcloud iam service-accounts add-iam-policy-binding \
    $ACCOUNT \
    --member="user:marcacohen@gmail.com" \
    --role="roles/iam.serviceAccountUser"

