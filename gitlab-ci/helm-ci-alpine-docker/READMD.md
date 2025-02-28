
1.  Build command
```
docker buildx --build-arg VERSION=3.3.4 . -t nathapp/helm:3.3.4-alpine-ci
```


docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg VERSION=3.10.1 \
             -t nathapp/helm:3.10.1-alpine-ci .  