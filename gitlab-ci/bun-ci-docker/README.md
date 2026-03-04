

docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.3.8 \
             -t nathapp/bun:1.3.8-ci .     