resource "aws_iam_role" "node_role" {
  count = (
    try(var.iam.node_role.arn, null) != null
    ) || (
    alltrue([for ng in coalesce(var.node_groups, []) : ng.node_role_arn != null])
  ) ? 0 : 1

  assume_role_policy = file("${path.module}/templates/iam/node-role-assume-role-policy.json")
  description        = "Default role used by nodegroups within the EKS cluster ${var.name}"
  name               = coalesce(try(var.iam.node_role.name, null), "eks-${var.name}-nodes")
  path               = try(var.iam.node_role.path, null)

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
