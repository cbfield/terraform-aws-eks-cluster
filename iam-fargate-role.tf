resource "aws_iam_role" "fargate_role" {
  count = try(var.iam.fargate_role.arn, null) == null && anytrue([
    for fp in var.fargate_profiles : fp.pod_execution_role_arn == null
  ]) ? 1 : 0

  description = "Default role for fargate profiles of the EKS cluster ${var.name}"
  name        = try(var.iam.fargate_role.name, "eks-${var.name}-fargate")
  path        = try(var.iam.fargate_role.path, null)

  assume_role_policy = templatefile(
    "${path.module}/templates/assume-role-policy.json.tpl", {
      service = "eks-fargate-pods"
    }
  )

  managed_policy_arns = coalesce(try(var.iam.fargate_role.managed_policy_arns, null), [
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy",
  ])

  tags = merge(try(var.iam.fargate_role.tags, {}), {
    "Managed By Terraform" = "true"
  })
}
