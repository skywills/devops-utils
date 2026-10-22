
1.  Build command
```
docker build --build-arg VERSION=18.20.2 --build-arg BUN_VERSION=1.1.12 . -t registry-intl.cn-hongkong.aliyuncs.com/gkci/bun-node:18.20.2-1.1.12-alpine-ci
```
```
docker build --build-arg VERSION=22.14.0 --build-arg BUN_VERSION=1.2.5 . -t registry-intl.cn-hongkong.aliyuncs.com/gkci/bun-node:22.14.0-1.2.5-alpine-ci
```

```
docker buildx build --platform linux/amd64,linux/arm64 \
--build-arg VERSION=22.14.0 --build-arg BUN_VERSION=1.2.5 . -t registry-intl.cn-hongkong.aliyuncs.com/gkci/bun-node:22.14.0-1.2.5-alpine-ci
```

```
docker buildx build --platform linux/amd64,linux/arm64 \
--build-arg VERSION=22.21.0 --build-arg BUN_VERSION=1.2.23 . -t registry-intl.cn-hongkong.aliyuncs.com/gkci/bun-node:22.21.0-1.2.23-alpine-ci
```

```
docker buildx build --platform linux/amd64,linux/arm64 \
--build-arg VERSION=22.21.0 --build-arg BUN_VERSION=1.3.9 . -t registry-intl.cn-hongkong.aliyuncs.com/gkci/bun-node:22.21.0-1.3.9-alpine-ci
```

```
docker buildx build --platform linux/amd64,linux/arm64 \
--build-arg VERSION=24.16.0 --build-arg BUN_VERSION=1.3.13 . -t registry-intl.cn-hongkong.aliyuncs.com/gkci/bun-node:24.16.0-1.3.13-alpine-ci
```
Docker Hub (used by the na-cli nestjs-api / nestjs-library CI templates). Build after `nathapp/node-bun:24.22.0-1.4.3-alpine` is pushed:
```
docker buildx build --platform linux/amd64,linux/arm64 \
--build-arg VERSION=24.22.0 --build-arg BUN_VERSION=1.4.3 . -t nathapp/node-bun:24.22.0-1.4.3-alpine-ci --push
```

bun 1.4.4 on the 2026-10-20/21 Node.js security releases. Build after the matching `nathapp/node-bun:<node>-1.4.4-alpine` is pushed:
```
docker buildx build --platform linux/amd64,linux/arm64 \
--build-arg VERSION=26.12.1 --build-arg BUN_VERSION=1.4.4 . -t nathapp/node-bun:26.12.1-1.4.4-alpine-ci --push
docker buildx build --platform linux/amd64,linux/arm64 \
--build-arg VERSION=24.22.1 --build-arg BUN_VERSION=1.4.4 . -t nathapp/node-bun:24.22.1-1.4.4-alpine-ci --push
docker buildx build --platform linux/amd64,linux/arm64 \
--build-arg VERSION=22.23.4 --build-arg BUN_VERSION=1.4.4 . -t nathapp/node-bun:22.23.4-1.4.4-alpine-ci --push
```
