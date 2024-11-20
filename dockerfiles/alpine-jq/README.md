

docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg VERSION=3.18 \
             -t nathapp/apline-jq:3.18 .    