
1.  build command
```
docker build --build-arg VERSION=18.20.2 . -t nathapp/node:18.20.2-alpine-ci

docker build --build-arg VERSION=22.23.1 . -t nathapp/node:22.23.1-alpine-ci

docker build --build-arg VERSION=24.18.0 . -t nathapp/node:24.18.0-alpine-ci

docker build --build-arg VERSION=26.5.0 . -t nathapp/node:26.5.0-alpine-ci
```