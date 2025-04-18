

docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.2.5 \
             -t nathapp/bun:1.2.5-alpine .     