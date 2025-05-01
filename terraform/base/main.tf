terraform {
  required_version = ">=1.7.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.26.0"
    }
  }
}

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
