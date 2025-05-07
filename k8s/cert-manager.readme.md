# Installation

```
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm upgrade --install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.16.1 \
  --set crds.enabled=true

```

# create cluster issuer
## Cloudflare
```
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: nathapp-letsencrypt-prod
spec:
  acme:
    email: williamkhoo@nathapp.com
    preferredChain: ""
    privateKeySecretRef:
      name: cluster-issuer-account-key
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - selector:
        dnsZones:
          - "nathapp.io"
      dns01:
        cloudflare:
          apiTokenSecretRef:
            key: api-token
            name: cloudflare-api-token
          email: williamkhoo@nathapp.com
```
## ingress solver
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    email: williamkhoo@nathapp.com
    preferredChain: ""
    privateKeySecretRef:
      name: cluster-issuer-account-key
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - http01:
        ingress:
          class: nginx

https://ruanbekker.hashnode.dev/cert-manager-dns-challenge-with-cloudflare-on-kubernetes

# create certificate or add cert-manager on ingress

```
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ssl-nathapp.io
spec:
  secretName: ssl-nathapp.io
  issuerRef:
    kind: ClusterIssuer
    name: nathapp-letsencrypt-prod
  commonName: nathapp.io
  dnsNames:
    - '*.nathapp.io'
```

cert manager on ingress
```
ingress:
  className: "nginx"
  annotations:
    cert-manager.io/cluster-issuer: nathapp-letsencrypt-prod
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /$1
    nginx.ingress.kubernetes.io/configuration-snippet: |
      gzip            on;
      gzip_min_length 20;
      gzip_types      text/plain application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png;
```