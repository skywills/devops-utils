ARG BUN_VERSION=1.1.34
FROM oven/bun:$BUN_VERSION

RUN apt-get update && \
    apt-get install -y --no-install-recommends git jq && \
    rm -rf /var/lib/apt/lists/*