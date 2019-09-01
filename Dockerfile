FROM ruby:2.6.4

RUN mkdir /app
WORKDIR /app

ENTRYPOINT ["./scripts/start.sh"]
