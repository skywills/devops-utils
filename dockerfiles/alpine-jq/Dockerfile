ARG VERSION=3.18
FROM alpine:${VERSION}

RUN apk update && apk --no-cache add jq

RUN mkdir /app
WORKDIR /app

ENTRYPOINT ["/usr/bin/jq"]