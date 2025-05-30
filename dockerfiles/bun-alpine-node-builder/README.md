

docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.2.5 \
             --build-arg NODE_VERSION=22.14.0 \
             -t nathapp/node-bun:22.14.0-1.2.5-alpine-builder .  



docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.2.15 \
             --build-arg NODE_VERSION=22.14.0 \
             -t nathapp/node-bun:22.14.0-1.2.15-alpine-builder .               