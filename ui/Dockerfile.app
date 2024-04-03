FROM us-central1-docker.pkg.dev/<PROJECT_ID>/quizaic/foundation

WORKDIR /usr/local/bin/app
COPY . /usr/local/bin/app

RUN flutter build web --release --web-renderer auto --dart-define=API_URL=<API_URL> --dart-define=REDIRECT_URI=<API_URL>/callback

# Document the exposed port and start server
EXPOSE 8080
ENTRYPOINT [ "/usr/local/bin/app/server.sh" ]
