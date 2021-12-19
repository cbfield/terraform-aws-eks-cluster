resource "aws_eks_addon" "addon" {
  for_each = var.create ? { for addon in var.addons : addon.name => addon } : {}

  addon_name               = each.value.name
  addon_version            = each.value.version
  cluster_name             = aws_eks_cluster.cluster[0].name
  resolve_conflicts        = each.value.resolve_conflicts
  service_account_role_arn = each.value.service_account_role_arn

  tags = merge(each.value.tags, {
    "Managed By Terraform" = "true"
  })
}
