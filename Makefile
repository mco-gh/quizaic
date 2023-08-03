WEBSITE_VERSION := 0.0.1
TAG             := ${REGION}-docker.pkg.dev/${PROJECT_ID}/quizrd/website:v${WEBSITE_VERSION}

fe-test:
	. scripts/env.sh && \
	. ~/keys.sh && \
	export REDIRECT_URI=http://localhost:8080/callback && \
	cd website && \
	flask run --port 8080 --debugger --reload

be-test:

fe-deploy:
	echo gcloud config set project ${PROJECT_ID}
	docker build -f website/Dockerfile -t ${TAG} .
	docker push ${TAG}
	gcloud run deploy website --region ${REGION} --image=${TAG} \
		--set-env-vars "${SITE_VARS}" --allow-unauthenticated

be-deploy:
