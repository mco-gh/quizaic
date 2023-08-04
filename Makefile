APP             := quizrd
WEBSITE_VERSION := 0.0.1
TAG             := ${REGION}-docker.pkg.dev/${PROJECT_ID}/quizrd/website:v${WEBSITE_VERSION}

export REGION=us-central1
export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value project)
export PROJECT_ID=$GOOGLE_CLOUD_PROJECT
export SESSION_BUCKET=${PROJECT_ID}-sessions
export REDIRECT_URI=https://quizrd.io/callback
#export REDIRECT_URI=$(gcloud run services describe website --region=$REGION --project $PROJECT_ID --format "value(status.url)")/callback
export API_URL=$(gcloud run services describe content-api --region=$REGION --project $PROJECT_ID --format "value(status.url)")

# env vars need work

fe-test:
	. ~/keys.sh && \
	export REDIRECT_URI=http://localhost:8080/callback && \
	cd website && \
	flask run --port 8080 --debugger --reload

be-test:

fe-deploy:
	gcloud config set project ${PROJECT_ID}
	docker build -f website/Dockerfile -t ${TAG} .
	docker push ${TAG}
	gcloud run deploy website --region ${REGION} --image=${TAG} \
		--set-env-vars "${SITE_VARS}" --allow-unauthenticated

be-deploy:
