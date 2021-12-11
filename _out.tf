output "enabled_cluster_log_types" {
  description = "The value provided for var.enabled_cluster_log_types"
  value       = var.enabled_cluster_log_types
}

output "iam" {
  description = "The value provided for var.iam"
  value       = var.iam
}

output "kubernetes_version" {
  description = "The value provided for var.kubernetes_version"
  value       = var.kubernetes_version
}

output "kubernetes_network_config" {
  description = "The value provided for var.kubernetes_network_config"
  value       = var.kubernetes_network_config
}

output "name" {
  description = "The value provided for var.name"
  value       = var.name
}

output "tags" {
  description = "The value provided for var.tags"
  value       = var.tags
}

output "vpc_config" {
  description = "The value provided for var.vpc_config"
  value       = var.vpc_config
}
