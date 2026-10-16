#!/usr/bin/env bash
# Create a ServiceAccount with cluster-admin or namespace-admin rights, then write a
# kubeconfig for it (for k9s or CI). Uses the current kubectl context as the target.
#
# Usage: kube-sa-create.sh [-r cluster|namespace] [-s sa-name] [-n namespace]
#                          [-t secret|DURATION] [-c cluster-name] [-o out-file] [-y]
#   -r  role scope: cluster   = cluster-admin on the whole cluster (ClusterRoleBinding)
#                   namespace = admin inside one namespace only (RoleBinding)
#   -s  ServiceAccount name
#   -n  namespace of the ServiceAccount (for "namespace" scope: the namespace it administers)
#   -t  token: "secret" = long-lived token Secret (revoke by deleting the Secret),
#             or a duration like 24h / 720h = short-lived token from `kubectl create token`
#   -c  cluster name used inside the kubeconfig (default: current context's cluster)
#   -o  kubeconfig output file (default: ./<sa>@<cluster>.kubeconfig)
#   -y  do not ask for confirmation
# Missing options are asked interactively.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

scope='' sa='' namespace='' token='' cluster='' out='' assume_yes=false
while getopts 'r:s:n:t:c:o:yh' opt; do
    case "$opt" in
        r) scope="$OPTARG" ;;
        s) sa="$OPTARG" ;;
        n) namespace="$OPTARG" ;;
        t) token="$OPTARG" ;;
        c) cluster="$OPTARG" ;;
        o) out="$OPTARG" ;;
        y) assume_yes=true ;;
        h) sed -n '2,16p' "$0"; exit 0 ;;
        *) exit 2 ;;
    esac
done

ask() { # ask <prompt> <default>
    local reply
    read -r -p "$1 [$2]: " reply
    printf '%s' "${reply:-$2}"
}

die() { echo "error: $*" >&2; exit 1; }

valid_name() { [[ "$1" =~ ^[a-z0-9]([-a-z0-9]*[a-z0-9])?$ ]] && [ "${#1}" -le 63 ]; }

command -v kubectl >/dev/null || die "kubectl not found on PATH"
context="$(kubectl config current-context 2>/dev/null)" || die "no current kubectl context"

if [ -z "$scope" ]; then
    echo "Role scope:"
    echo "  1) cluster   - cluster-admin on the whole cluster"
    echo "  2) namespace - admin inside one namespace only"
    case "$(ask 'Choose' '2')" in
        1|cluster) scope=cluster ;;
        2|namespace) scope=namespace ;;
        *) die "invalid choice" ;;
    esac
fi
case "$scope" in cluster|namespace) ;; *) die "-r must be cluster or namespace" ;; esac

[ -n "$sa" ] || sa="$(ask 'ServiceAccount name' "${scope}-admin")"
if [ -z "$namespace" ]; then
    if [ "$scope" = cluster ]; then
        namespace="$(ask 'Namespace for the ServiceAccount' 'kube-system')"
    else
        namespace="$(ask 'Namespace to administer' 'default')"
    fi
fi
[ -n "$token" ] || token="$(ask 'Token: "secret" (long-lived) or a duration like 24h' 'secret')"
valid_name "$sa" || die "invalid ServiceAccount name: $sa"
valid_name "$namespace" || die "invalid namespace: $namespace"
[[ "$token" = secret || "$token" =~ ^[0-9]+[smh]$ ]] || die "-t must be 'secret' or a duration like 24h"

binding_name="${sa}-${scope}-admin"
echo
echo "Context:        $context"
echo "ServiceAccount: $namespace/$sa"
if [ "$scope" = cluster ]; then
    echo "Grant:          ClusterRoleBinding $binding_name -> ClusterRole cluster-admin (whole cluster)"
else
    echo "Grant:          RoleBinding $namespace/$binding_name -> ClusterRole admin (namespace $namespace only)"
fi
echo "Token:          $token"
if [ "$assume_yes" != true ]; then
    [ "$(ask 'Apply to this cluster? (y/N)' 'N')" = y ] || { echo "aborted"; exit 1; }
fi

kubectl get namespace "$namespace" >/dev/null 2>&1 || kubectl create namespace "$namespace"
kubectl -n "$namespace" create serviceaccount "$sa" --dry-run=client -o yaml | kubectl apply -f -

if [ "$scope" = cluster ]; then
    kubectl create clusterrolebinding "$binding_name" --clusterrole=cluster-admin \
        --serviceaccount="$namespace:$sa" --dry-run=client -o yaml | kubectl apply -f -
else
    kubectl -n "$namespace" create rolebinding "$binding_name" --clusterrole=admin \
        --serviceaccount="$namespace:$sa" --dry-run=client -o yaml | kubectl apply -f -
fi

if [ "$token" = secret ]; then
    # Since Kubernetes 1.24 token Secrets are no longer created automatically.
    kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: ${sa}-token
  namespace: ${namespace}
  annotations:
    kubernetes.io/service-account.name: ${sa}
type: kubernetes.io/service-account-token
EOF
fi

args=(-s "$sa" -n "$namespace" -t "$token")
[ -n "$cluster" ] && args+=(-c "$cluster")
[ -n "$out" ] && args+=(-o "$out")
"$SCRIPT_DIR/kube-sa-kubeconfig.sh" "${args[@]}"
