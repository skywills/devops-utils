

docker build --build-arg BUN_VERSION=1.1.7 \
             --build-arg NODE_VERSION=18.20.2 \
             -t nathapp/node-bun:18.20.2-1.1.7-alpine .

docker build --build-arg BUN_VERSION=1.1.7 \
             --build-arg NODE_VERSION=20.13.1 \
             -t nathapp/node-bun:20.13.1-1.1.7-alpine .