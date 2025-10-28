https://docs.docker.com/build/building/multi-platform/

docker build --build-arg BUN_VERSION=1.1.7 \
             --build-arg NODE_VERSION=18.20.2 \
             -t nathapp/node-bun:18.20.2-1.1.7-alpine .

docker build --build-arg BUN_VERSION=1.1.7 \
             --build-arg NODE_VERSION=20.13.1 \
             -t nathapp/node-bun:20.13.1-1.1.7-alpine .


docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.1.12 \
             --build-arg NODE_VERSION=18.20.2 \
             --build-arg ALPINE_VERSION=3.18 \
             -t nathapp/node-bun:18.20.2-1.1.12-alpine .             

docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.1.12 \
             --build-arg NODE_VERSION=20.13.1 \
             -t nathapp/node-bun:20.13.1-1.1.12-alpine .


docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.1.37 \
             --build-arg NODE_VERSION=18.20.5 \
             --build-arg ALPINE_VERSION=3.21 \
             -t nathapp/node-bun:18.20.5-1.1.37-alpine .          

docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.2.5 \
             --build-arg NODE_VERSION=22.14.0 \
             --build-arg ALPINE_VERSION=3.21 \
             -t nathapp/node-bun:22.14.0-1.2.5-alpine .                     


docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.2.15 \
             --build-arg NODE_VERSION=22.14.0 \
             --build-arg ALPINE_VERSION=3.21 \
             -t nathapp/node-bun:22.14.0-1.2.15-alpine .             

docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.3.1 \
             --build-arg NODE_VERSION=22.21.0 \
             --build-arg ALPINE_VERSION=3.22 \
             -t nathapp/node-bun:22.21.0-1.3.1-alpine .              