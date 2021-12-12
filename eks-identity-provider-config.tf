resource "aws_eks_identity_provider_config" "identity" {
  count = var.identity_provider_config != null ? 1 : 0

  cluster_name = aws_eks_cluster.cluster.name

  oidc {
    client_id                     = var.identity_provider_config.oidc.client_id
    groups_claim                  = var.identity_provider_config.oidc.groups_claim
    groups_prefix                 = var.identity_provider_config.oidc.groups_prefix
    identity_provider_config_name = var.identity_provider_config.oidc.identity_provider_config_name
    issuer_url                    = var.identity_provider_config.oidc.issuer_url
    required_claims               = var.identity_provider_config.oidc.required_claims
    username_claim                = var.identity_provider_config.oidc.username_claim
    username_prefix               = var.identity_provider_config.oidc.username_prefix
  }

  tags = merge(try(var.identity_provider_config.tags, null), {
    "Managed By Terraform" = "true"
  })
}
