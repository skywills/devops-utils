https://forum.gitlab.com/t/is-the-docker-daemon-running-dind/90022/6

gitlabUrl: https://REDACTED
certsSecretName: gitlab-runner-ca
concurrent: 10
check_interval: 1
log_level: "debug"
rbac:
  create: true
  clusterWideAccess: true
  serviceAccountName: gitlab-runner
  rules:
    - resources: ["configmaps", "pods", "pods/attach", "secrets", "services"]
      verbs: ["get", "list", "watch", "create", "patch", "delete"]
    - resources: ["secrets"]
      verbs: ["get", "list", "watch", "create", "patch", "update", "delete"]
    - resources: ["serviceAccounts"]
      verbs: ["get"]
    - apiGroups: [""]
      resources: ["pods/exec"]
      verbs: ["create", "patch", "delete"]
runners:
  secret: gitlab-runner-secret
  config: |
    [[runners]]
      name = "Kubernetes GitLab Runner"
      executor = "kubernetes"
      shell = "bash"
      [runners.kubernetes]
        namespace = "gitlab-runner"
        terminationGracePeriodSeconds = 5
        privileged = true
        allow_privilege_escalation = true
        image = "alpine"
        ca_file = "gitlab-runner-ca"
      [[runners.kubernetes.volumes.secret]]
        name = "gitlab-runner-ca"
        mount_path = "/etc/gitlab-runner/certs/"