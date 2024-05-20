resource "aws_eks_addon" "this" {
  for_each = var.create ? { for addon in var.addons : addon.name => addon } : {}

  addon_name               = each.value.name
  addon_version            = each.value.version
  cluster_name             = aws_eks_cluster.this[0].name
  service_account_role_arn = each.value.service_account_role_arn
  tags                     = each.value.tags
}
