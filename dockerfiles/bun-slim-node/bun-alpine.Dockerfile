ARG NODE_VERSION=18.20.1
FROM node:$NODE_VERSION-alpine
ARG BUN_VERSION=1.1.7
ARG TARGET=linux-x64-baseline

RUN apk add --no-cache bash curl unzip && \
 curl https://bun.sh/install | bash -s -- bun-v${BUN_VERSION} && \
 ln -s $HOME/.bun/bin/bun /usr/local/bin/bun