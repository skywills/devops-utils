

docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg VERSION=28.1.1 \
             -t nathapp/docker-ci:28.1.1 .    