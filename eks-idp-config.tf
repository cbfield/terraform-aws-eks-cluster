resource "aws_eks_identity_provider_config" "this" {
  for_each = var.create ? { for idp in var.identity_provider_config : idp.oidc.client_id => idp } : {}

  cluster_name = aws_eks_cluster.this[0].name
  tags         = each.value.tags

  oidc {
    client_id                     = each.value.oidc.client_id
    groups_claim                  = each.value.oidc.groups_claim
    groups_prefix                 = each.value.oidc.groups_prefix
    identity_provider_config_name = each.value.oidc.identity_provider_config_name
    issuer_url                    = each.value.oidc.issuer_url
    required_claims               = each.value.oidc.required_claims
    username_claim                = each.value.oidc.username_claim
    username_prefix               = each.value.oidc.username_prefix
  }
}
