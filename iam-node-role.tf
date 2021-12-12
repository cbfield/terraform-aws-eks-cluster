resource "aws_iam_role" "node_role" {
  count = (
    try(var.iam.node_role.arn, null) != null
    ) || (
    alltrue([for ng in var.node_groups : ng.node_role_arn != null])
  ) ? 0 : 1

  description = "Default role used by nodegroups within the EKS cluster ${var.name}"
  name        = coalesce(try(var.iam.node_role.name, null), "eks-${var.name}-nodes")
  path        = try(var.iam.node_role.path, null)

  assume_role_policy = templatefile(
    "${path.module}/templates/assume-role-policy.json.tpl", {
      service = "ec2"
  })

  managed_policy_arns = distinct(concat(
    coalesce(try(var.iam.node_role.managed_policy_arns, []), []),
    [
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    ]
  ))

  tags = merge(try(var.iam.node_role.tags, null), {
    "Managed By Terraform" = "true"
  })
}
