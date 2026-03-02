resource "kubernetes_namespace" "onepassword" {
  metadata {
    name = "onepassword"
  }
}

resource "kubernetes_manifest" "op" {
  computed_fields = ["stringData"]
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Secret"
    "metadata" = {
      "name"      = "op-credentials"
      "namespace" = kubernetes_namespace.onepassword.metadata[0].name
    }
    "stringData" = {
      "1password-credentials.json" = base64encode(var.onepassword_credentials)
    }
    "type" = "Opaque"
  }
}

resource "kubernetes_manifest" "op_token" {
  computed_fields = ["stringData"]
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Secret"
    "metadata" = {
      "name"      = "onepassword-token"
      "namespace" = kubernetes_namespace.onepassword.metadata[0].name
    }
    "stringData" = {
      "token" = base64encode(var.onepassword_token)
    }
    "type" = "Opaque"
  }
}
