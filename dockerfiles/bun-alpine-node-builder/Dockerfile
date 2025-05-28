ARG NODE_VERSION=18.20.2
ARG BUN_VERSION=latest
FROM nathapp/node-bun:${NODE_VERSION}-${BUN_VERSION}-alpine

RUN apk update && apk add --no-cache jq
RUN bun install -g json5