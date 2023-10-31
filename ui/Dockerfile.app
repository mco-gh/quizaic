FROM us-central1-docker.pkg.dev/quizaic/quizaic/foundation

WORKDIR /usr/local/bin/app
COPY . /usr/local/bin/app

RUN flutter build web --release --web-renderer auto --dart-define=API_URL=https://api-co24gukjmq-uc.a.run.app --dart-define=REDIRECT_URI=https://api-co24gukjmq-uc.a.run.app/callback

# Document the exposed port and start server
EXPOSE 8080
ENTRYPOINT [ "/usr/local/bin/app/server.sh" ]
