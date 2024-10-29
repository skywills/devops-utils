FROM alpine:3.18

RUN apk update \
 && apk add jq \
 && rm -rf /var/cache/apk/*

RUN mkdir /app
WORKDIR /app

ENTRYPOINT ["/usr/bin/jq"]