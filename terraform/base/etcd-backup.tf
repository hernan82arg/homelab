resource "kubernetes_manifest" "etcd_backup_service_account" {
  manifest = {
    apiVersion = "talos.dev/v1alpha1"
    kind       = "ServiceAccount"
    metadata = {
      name      = "etcd-backup-talos-secrets"
      namespace = "kube-system"
    }
    spec = {
      roles = [
        "os:etcd:backup"
      ]
    }
  }
}
