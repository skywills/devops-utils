
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