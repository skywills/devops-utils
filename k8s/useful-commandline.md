
## to get ingress with specify annotation

### Show only Ingress names
```
kubectl get ingress --all-namespaces -o json | \
jq -r '.items[] | select(.metadata.annotations["nginx.ingress.kubernetes.io/configuration-snippet"]) | "\(.metadata.namespace)/\(.metadata.name)"'
```

### Filter by namespace
The grep -v 'null' filters out Ingresses without that annotation.
The \. are escapes needed for the dot characters in the annotation key.
```
kubectl get ingress -n svc -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.metadata.annotations.nginx\.ingress\.kubernetes\.io/configuration-snippet}{"\n"}{end}' | grep -v 'null'

```


## to get pods with volume mount

### list all pods that have any volumes mounted
```
kubectl get pods -A -o jsonpath='{range .items[?(@.spec.volumes)]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}{end}'
```

## list with volume type. eg: PVC
```
kubectl get pods -A -o jsonpath='{range .items[?(@.spec.volumes[*].persistentVolumeClaim)]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}{end}'
```


## to get pods with node selector
```
kubectl get pods -A -o jsonpath='{range .items[?(@.spec.nodeSelector)]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}{end}'
```

## print node selector as well
```
kubectl get pods -A -o jsonpath='{range .items[?(@.spec.nodeSelector)]}{.metadata.namespace}{"\t"}{.metadata.name}{"\t"}{.spec.nodeSelector}{"\n"}{end}'
```


### to check pod using hostPath
```
kubectl get pods -A -o json | jq -r '.items[]
  | select(.spec.volumes != null)
  | select(any(.spec.volumes[]; has("hostPath")))
  | [.metadata.namespace, .metadata.name, (.spec.volumes[] | select(has("hostPath")).name), (.spec.volumes[] | select(has("hostPath")).hostPath.path)]
  | @tsv'
```

```
kubectl get pods -A -o json | jq -r '.items[] | select(any(.spec.volumes[]?; has("hostPath"))) | [.metadata.namespace, .metadata.name] | @tsv'
```

```
kubectl get deploy,ds,sts -A -o json | jq -r '.items[]
  | select(.spec.template.spec.volumes != null)
  | select(any(.spec.template.spec.volumes[]; has("hostPath")))
  | [.kind, .metadata.namespace, .metadata.name, (.spec.template.spec.volumes[] | select(has("hostPath")).hostPath.path)]
  | @tsv'
```