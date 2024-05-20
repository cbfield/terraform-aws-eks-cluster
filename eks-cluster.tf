resource "aws_eks_cluster" "this" {
  count = var.create ? 1 : 0

  enabled_cluster_log_types = var.enabled_cluster_log_types
  name                      = var.name
  version                   = var.kubernetes_version
  tags                      = var.tags

  role_arn = coalesce(
    try(var.iam.cluster_role.arn, null),
    try(aws_iam_role.cluster_role.0.arn, null)
  )

  encryption_config {
    resources = coalesce(try(var.encryption_config.resources, null), ["secrets"])

    provider {
      key_arn = coalesce(
        try(var.encryption_config.provider.key_arn, null),
        try(aws_kms_key.this.0.arn, null)
      )
    }
  }

  kubernetes_network_config {
    service_ipv4_cidr = try(var.kubernetes_network_config.service_ipv4_cidr, null)
  }

  vpc_config {
    endpoint_private_access = coalesce(var.vpc_config.endpoint_private_access, true)
    endpoint_public_access  = coalesce(var.vpc_config.endpoint_public_access, false)
    public_access_cidrs     = var.vpc_config.public_access_cidrs
    security_group_ids      = var.vpc_config.security_group_ids
    subnet_ids              = var.vpc_config.subnet_ids
  }

  depends_on = [aws_cloudwatch_log_group.this[0]]
}
