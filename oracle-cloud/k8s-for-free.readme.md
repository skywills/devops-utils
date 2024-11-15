https://me.mattscott.cloud/kubernetes-on-oracle-cloud-for-free/


## it is good to use service account to run for kubeconfig for OCI k8s
https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/Content/ContEng/Tasks/contengaddingserviceaccttoken.htm

1.  create service account
```
kubectl -n kube-system create serviceaccount <service-account-name>
```
kubectl -n kube-system create serviceaccount kubeconfig-sa

2.  create cluster role binding
```
kubectl create clusterrolebinding <binding-name> --clusterrole=cluster-admin --serviceaccount=kube-system:<service-account-name>
```
kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:kubeconfig-sa


3. apply service account secret
```
kubectl apply -f service-account-secret.yml
```

4. obtain token
```
kubectl -n kube-system get secret oke-kubeconfig-sa-token -o jsonpath='{.data.token}'
```

5. replace token as below sample

```
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FUR [...]
    server: https://212.7.193.11:6443
  name: k8s-0000001
contexts:
- context:
    cluster: k8s-0000001
    user: laurent-sa # <- This is what need to be change
  name: k8s-0000001
current-context: k8s-0000001
kind: Config
preferences: {}
users:
- name: laurent-sa # <- This is what need to be change
  user: # Change the certificate section for a token section as shown below.
    token: eyJhbGciOiJSUzI1NiIsImtpZCI6InBqZUFJOFJvbnNWQ19odGJrdGwzTnY3TXRJX29HS0dIekVsQmlJZzZ6R0kifQ.eyJ [...] # <- This is what need to be change
```