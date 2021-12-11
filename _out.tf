output "enabled_cluster_log_types" {
  description = "The value provided for var.enabled_cluster_log_types"
  value       = var.enabled_cluster_log_types
}

output "cluster" {
  description = "The EKS cluster itself"
  value       = aws_eks_cluster.cluster
}

output "cluster_role" {
  description = "The role created for use as the cluster role, if one wasn't provided"
  value       = one(aws_iam_role.cluster_role)
}

output "encryption_key" {
  description = "The KMS key created to encrypt objects within the cluster, if one wasn't provided"
  value       = one(aws_kms_key.key)
}

output "encryption_key_arn" {
  description = "The KMS alias created for the encryption key, if a key wasn't provided"
  value       = one(aws_kms_alias.alias)
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
