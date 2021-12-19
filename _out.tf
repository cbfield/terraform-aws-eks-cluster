output "addons" {
  description = "Addons installed in the cluster"
  value       = aws_eks_addon.addon
}

output "aws_auth" {
  description = "The value provided for var.aws_auth"
  value       = var.aws_auth
}

output "enabled_cluster_log_types" {
  description = "The value provided for var.enabled_cluster_log_types"
  value       = var.enabled_cluster_log_types
}

output "cluster" {
  description = "The EKS cluster itself"
  value       = aws_eks_cluster.cluster
}

output "cluster_auth" {
  description = "Kube API auth for the cluster"
  value       = data.aws_eks_cluster_auth.auth
  sensitive   = true
}

output "cluster_role" {
  description = "The role created for use as the cluster role, if one wasn't provided"
  value       = one(aws_iam_role.cluster_role)
}

output "default_compute_subnet_ids" {
  description = "The value provided for var.default_compute_subnet_ids"
  value       = var.default_compute_subnet_ids
}

output "encryption_key" {
  description = "The KMS key created to encrypt objects within the cluster, if one wasn't provided"
  value       = one(aws_kms_key.key)
}

output "encryption_key_arn" {
  description = "The KMS alias created for the encryption key, if a key wasn't provided"
  value       = one(aws_kms_alias.alias)
}

output "fargate_profiles" {
  description = "Fargate profiles created within the cluster"
  value       = aws_eks_fargate_profile.fargate_profile
}

output "iam" {
  description = "The value provided for var.iam"
  value       = var.iam
}

output "identity_provider_config" {
  description = "IdP configurations used by the cluster"
  value       = aws_eks_identity_provider_config.identity
}

output "kubernetes_version" {
  description = "The value provided for var.kubernetes_version"
  value       = var.kubernetes_version
}

output "kubernetes_network_config" {
  description = "The value provided for var.kubernetes_network_config"
  value       = var.kubernetes_network_config
}

output "log_group" {
  description = "The Cloudwatch log group created for cluster logs"
  value       = aws_cloudwatch_log_group.logs
}

output "name" {
  description = "The value provided for var.name"
  value       = var.name
}

output "node_groups" {
  description = "Node groups created within the cluster"
  value       = aws_eks_node_group.node_group
}

output "oidc_provider" {
  description = "The OIDC provider created from the cluster"
  value       = one(aws_iam_openid_connect_provider.cluster)
}

output "tags" {
  description = "Tags assigned to the cluster"
  value = merge(var.tags, {
    "Managed By Terraform" = "true"
  })
}

output "vpc_config" {
  description = "The value provided for var.vpc_config"
  value       = var.vpc_config
}
