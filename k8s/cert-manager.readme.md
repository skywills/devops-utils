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
```
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
 name: cluster-issuer-letsencrypt-prod
spec:
 acme:
   server: https://acme-v02.api.letsencrypt.org/directory
   email: me@example.com
 privateKeySecretRef:
   name: cluster-letsencrypt-prod
solvers:
- http01:
    ingress:
      class: traefik
  selector: {}
```