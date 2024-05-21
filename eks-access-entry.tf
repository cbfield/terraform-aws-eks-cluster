resource "aws_eks_access_entry" "this" {
  for_each = var.create ? {
    for entry in var.access_entries : "${entry.principal_arn}-${join(",", entry.k8s_groups)}-${entry.type}" => entry
  } : {}

  cluster_name      = aws_eks_cluster.this[0].name
  principal_arn     = each.value.principal_arn
  kubernetes_groups = each.value.k8s_groups
  tags              = each.value.tags
  type              = each.value.type
  user_name         = each.value.user_name
}

resource "aws_eks_access_policy_association" "example" {
  for_each = var.create ? {
    for assoc in flatten([
      for entry in var.access_entries : [
        for policy in entry.policy_associations : {
          principal_arn    = entry.principal_arn
          policy_arn       = policy.policy_arn
          scope_type       = policy.scope_type
          scope_namespaces = policy.scope_namespaces
        }
      ]
    ]) : "${assoc.principal_arn}-${assoc.policy_arn}-${assoc.scope_type}-${join(",", coalesce(assoc.scope_namespaces, ["none"]))}" => assoc
  } : {}

  cluster_name  = aws_eks_cluster.this[0].name
  policy_arn    = each.value.policy_arn
  principal_arn = each.value.principal_arn

  access_scope {
    type       = each.value.scope_type
    namespaces = each.value.scope_namespaces
  }
}
