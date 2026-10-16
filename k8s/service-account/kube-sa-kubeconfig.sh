#!/usr/bin/env bash
# Write a kubeconfig for an existing ServiceAccount (for k9s or CI).
# Uses the current kubectl context to read the cluster address and CA.
#
# Usage: kube-sa-kubeconfig.sh -s sa-name -n namespace [-N context-namespace] [-t secret|DURATION]
#                              [-c cluster-name] [-o out-file | -o -]
#   -n  namespace the ServiceAccount (and its token Secret) lives in
#   -N  default namespace of the kubeconfig context, and where access is checked
#       (default: -n). Set it when the account administers another namespace.
#   -t  "secret" (default) = read the long-lived token Secret <sa>-token,
#       or a duration like 24h = mint a short-lived token with `kubectl create token`
#   -c  cluster name used inside the kubeconfig (default: current context's cluster)
#   -o  output file (default: ./<sa>@<cluster>.kubeconfig, mode 600); "-" = stdout
#
# Then: k9s --kubeconfig <file>   or   KUBECONFIG=<file> kubectl get pods
set -euo pipefail

sa='' namespace='' ctx_namespace='' token=secret cluster='' out=''
while getopts 's:n:N:t:c:o:h' opt; do
    case "$opt" in
        s) sa="$OPTARG" ;;
        n) namespace="$OPTARG" ;;
        N) ctx_namespace="$OPTARG" ;;
        t) token="$OPTARG" ;;
        c) cluster="$OPTARG" ;;
        o) out="$OPTARG" ;;
        h) sed -n '2,15p' "$0"; exit 0 ;;
        *) exit 2 ;;
    esac
done

die() { echo "error: $*" >&2; exit 1; }

[ -n "$sa" ] && [ -n "$namespace" ] || die "-s and -n are required (see -h)"
[ -n "$ctx_namespace" ] || ctx_namespace="$namespace"
[[ "$token" = secret || "$token" =~ ^[0-9]+[smh]$ ]] || die "-t must be 'secret' or a duration like 24h"

server="$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')"
[ -n "$server" ] || die "cannot read the server address from the current context"
[ -n "$cluster" ] || cluster="$(kubectl config view --minify -o jsonpath='{.clusters[0].name}')"

# Every namespace has the cluster CA in the kube-root-ca.crt ConfigMap.
ca="$(kubectl -n "$namespace" get configmap kube-root-ca.crt -o jsonpath='{.data.ca\.crt}' | base64 | tr -d '\n')"
[ -n "$ca" ] || die "cannot read kube-root-ca.crt in namespace $namespace"

if [ "$token" = secret ]; then
    secret="${sa}-token"
    value=''
    for _ in $(seq 1 30); do # the token controller fills the Secret asynchronously
        value="$(kubectl -n "$namespace" get secret "$secret" -o jsonpath='{.data.token}' 2>/dev/null || true)"
        [ -n "$value" ] && break
        sleep 1
    done
    [ -n "$value" ] || die "secret $namespace/$secret has no token (does it exist? run kube-sa-create.sh)"
    bearer="$(printf '%s' "$value" | base64 --decode)"
else
    bearer="$(kubectl -n "$namespace" create token "$sa" --duration="$token")"
fi

context_name="${sa}@${cluster}"
config="apiVersion: v1
kind: Config
clusters:
  - name: ${cluster}
    cluster:
      certificate-authority-data: ${ca}
      server: ${server}
contexts:
  - name: ${context_name}
    context:
      cluster: ${cluster}
      namespace: ${ctx_namespace}
      user: ${sa}
users:
  - name: ${sa}
    user:
      token: ${bearer}
current-context: ${context_name}
"

if [ "$out" = - ]; then
    printf '%s' "$config"
    exit 0
fi

[ -n "$out" ] || out="./${context_name}.kubeconfig"
(umask 077 && printf '%s' "$config" > "$out")
chmod 600 "$out"

# Prove the credentials work before handing them out.
if KUBECONFIG="$out" kubectl auth can-i get pods -n "$ctx_namespace" >/dev/null 2>&1; then
    check="ok (can get pods in $ctx_namespace)"
else
    check="FAILED (token cannot get pods in $ctx_namespace)"
fi
echo "Wrote $out (mode 600) - access check: $check"
echo "Open with: k9s --kubeconfig $out"
