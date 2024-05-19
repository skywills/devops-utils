

docker build --build-arg BUN_VERSION=1.1.7 \
             --build-arg NODE_MAJOR_VERSION=18 \
             -t nathapp/node-bun:18-1.1.7-slim .

docker build --build-arg BUN_VERSION=1.1.7 \
             --build-arg NODE_MAJOR_VERSION=20 \
             -t nathapp/node-bun:20-1.1.7-slim .