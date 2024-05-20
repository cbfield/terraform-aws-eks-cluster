resource "aws_eks_fargate_profile" "this" {
  for_each = var.create ? { for fp in var.fargate_profiles : fp.name => fp } : {}

  cluster_name         = aws_eks_cluster.this[0].name
  fargate_profile_name = each.value.name
  tags                 = each.value.tags

  pod_execution_role_arn = coalesce(
    each.value.pod_execution_role_arn,
    try(var.iam.fargate_role.arn, null),
    try(aws_iam_role.fargate_role.0.arn, null)
  )

  subnet_ids = coalesce(
    each.value.subnet_ids,
    var.default_compute_subnet_ids
  )

  dynamic "selector" {
    for_each = {
      for s in coalesce(each.value.selectors, []) : join("-", concat(
        [s.namespace],
        [join(",", [for key, value in coalesce(s.labels, {}) : "${key}:${value}"])]
      )) => s
    }
    content {
      namespace = selector.value.namespace
      labels    = selector.value.labels
    }
  }
}
