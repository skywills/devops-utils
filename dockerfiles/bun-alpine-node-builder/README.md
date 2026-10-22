

docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.2.5 \
             --build-arg NODE_VERSION=22.14.0 \
             -t nathapp/node-bun:22.14.0-1.2.5-alpine-builder .  

docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.2.5 \
             --build-arg NODE_VERSION=22.21.0 \
             -t nathapp/node-bun:22.21.0-1.2.5-alpine-builder . 

docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.2.23 \
             --build-arg NODE_VERSION=22.21.0 \
             -t nathapp/node-bun:22.21.0-1.2.23-alpine-builder .              


docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.3.1 \
             --build-arg NODE_VERSION=22.21.0 \
             -t nathapp/node-bun:22.21.0-1.3.1-alpine-builder .               


docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.3.9 \
             --build-arg NODE_VERSION=22.21.0 \
             --build-arg ALPINE_VERSION=3.22 \
             -t nathapp/node-bun:22.21.0-1.3.9-alpine-builder .        

docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.3.13 \
             --build-arg NODE_VERSION=24.16.0 \
             --build-arg ALPINE_VERSION=3.22 \
             -t nathapp/node-bun:24.16.0-1.3.13-alpine-builder .                  
## build after nathapp/node-bun:24.22.0-1.4.3-alpine is pushed (FROM resolves it from Docker Hub)
docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.4.3 \
             --build-arg NODE_VERSION=24.22.0 \
             -t nathapp/node-bun:24.22.0-1.4.3-alpine-builder --push .

## bun 1.4.4 on the 2026-10-20/21 Node.js security releases (build after the matching -alpine base is pushed)
docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.4.4 \
             --build-arg NODE_VERSION=26.12.1 \
             -t nathapp/node-bun:26.12.1-1.4.4-alpine-builder --push .
docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.4.4 \
             --build-arg NODE_VERSION=24.22.1 \
             -t nathapp/node-bun:24.22.1-1.4.4-alpine-builder --push .
docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg BUN_VERSION=1.4.4 \
             --build-arg NODE_VERSION=22.23.4 \
             -t nathapp/node-bun:22.23.4-1.4.4-alpine-builder --push .
