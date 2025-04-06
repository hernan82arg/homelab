terraform {
  required_version = ">=1.7.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.26.0"
    }
  }
}

resource "kubernetes_namespace" "tapo" {
  metadata {
    name = "tapo"
  }
}

resource "kubernetes_secret" "tapo_credentials" {
  metadata {
    name = "tapo-credentials"
    namespace = kubernetes_namespace.tapo.metadata[0].name
  }
  data = {
    TAPO_EMAIL = var.tapo_username
    TAPO_PASSWORD = var.tapo_password
    AUTH_PASSWORD = var.tapo_auth_password
    }
  type = "Opaque"
}
