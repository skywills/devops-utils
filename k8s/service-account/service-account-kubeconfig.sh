# The script returns a kubeconfig for the ServiceAccount given
# you need to have kubectl on PATH with the context set to the cluster you want to create the config for

# Cosmetics for the created config
clusterName='example-cluster'
# your server address goes here get it via `kubectl cluster-info`
server=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
# the Namespace and ServiceAccount name that is used for the config
namespace='example'
serviceAccount='ingress-service-account'

# the secret name that holds the token and ca.crt is created on service-account.yaml
secretName=example-service-account-token

######################
# actual script starts
set -o errexit


ca=$(kubectl --namespace="$namespace" get secret/"$secretName" -o=jsonpath='{.data.ca\.crt}')
token=$(kubectl --namespace="$namespace" get secret/"$secretName" -o=jsonpath='{.data.token}' | base64 --decode)

echo "
---
apiVersion: v1
kind: Config
clusters:
  - name: ${clusterName}
    cluster:
      certificate-authority-data: ${ca}
      server: ${server}
contexts:
  - name: ${serviceAccount}@${clusterName}
    context:
      cluster: ${clusterName}
      namespace: ${namespace}
      user: ${serviceAccount}
users:
  - name: ${serviceAccount}
    user:
      token: ${token}
current-context: ${serviceAccount}@${clusterName}
"