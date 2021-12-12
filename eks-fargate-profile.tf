resource "aws_eks_fargate_profile" "fargate_profile" {
  for_each = { for fp in coalesce(var.fargate_profiles, []) : fp.name => fp }

  cluster_name         = aws_eks_cluster.cluster.name
  fargate_profile_name = each.value.name

  pod_execution_role_arn = coalesce(
    each.value.pod_execution_role_arn,
    try(var.iam.fargate_role.arn, null),
    try(aws_iam_role.fargate_role.0.arn, null),
  )

  subnet_ids = coalesce(
    each.value.subnet_ids,
    var.vpc_config.subnet_ids
  )

  dynamic "selector" {
    for_each = {
      for s in coalesce(each.value.selectors, []) : (
        "${s.namespace}-${coalesce(
          join(",", [for key, value in coalesce(s.labels, {}) : "${key}:${value}"]),
          "nolabels"
        )}"
      ) => s
    }
    content {
      namespace = selector.value.namespace
      labels    = selector.value.labels
    }
  }

  tags = merge(each.value.tags, {
    "Managed By Terraform" = "true"
  })
}
