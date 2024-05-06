ARG BUN_VERSION=1.1.7-slim
FROM oven/bun:${BUN_VERSION}
ARG NODE_MAJOR_VERSION=18
RUN apt-get update && apt-get install -y curl
RUN curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x" | bash -
RUN apt-get install -y nodejs