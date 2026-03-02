resource "kubernetes_namespace" "data" {
  metadata {
    name = "data"
  }
}

resource "kubernetes_secret" "redis_password" {
  metadata {
    name      = "redis-password"
    namespace = kubernetes_namespace.data.metadata[0].name
  }
  data = {
    "password" = var.redis_password
  }
}
