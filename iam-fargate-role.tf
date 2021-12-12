resource "aws_iam_role" "fargate_role" {
  count = (
    try(var.iam.fargate_role.arn, null) != null
    ) || (
    alltrue([for fp in coalesce(var.fargate_profiles, []) : fp.pod_execution_role_arn != null])
  ) ? 0 : 1

  assume_role_policy = file("${path.module}/templates/iam/fargate-role-assume-role-policy.json")
  description        = "Default role used by fargate profiles within the EKS cluster ${var.name}"
  name               = coalesce(try(var.iam.fargate_role.name, null), "eks-${var.name}-fargate")
  path               = try(var.iam.fargate_role.path, null)

  managed_policy_arns = distinct(concat(
    coalesce(try(var.iam.fargate_role.managed_policy_arns, []), []),
    ["arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"]
  ))

  tags = merge(try(var.iam.fargate_role.tags, null), {
    "Managed By Terraform" = "true"
  })
}
