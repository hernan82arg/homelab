variable "redis_password" {
  type        = string
  description = "Redis password"
  sensitive   = true
}

variable "onepassword_credentials" {
  type        = string
  description = "1Password credentials"
  sensitive   = true
}

variable "onepassword_token" {
  type        = string
  description = "1Password token"
  sensitive   = true
}
