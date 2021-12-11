resource "aws_iam_role" "cluster_role" {
  count = try(var.iam.cluster_role.arn, null) == null ? 1 : 0

  assume_role_policy = file("${path.module}/templates/iam/cluster-role-assume-role-policy.json")
  description        = "Role used by the EKS cluster ${var.name}"
  name               = coalesce(try(var.iam.cluster_role.name, null), "eks-${var.name}-cluster")
  path               = try(var.iam.cluster_role.path, null)

  managed_policy_arns = distinct(concat(
    coalesce(try(var.iam.cluster_role.managed_policy_arns, []), []),
    ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
  ))

  tags = merge(try(var.iam.cluster_role.tags, null), {
    "Managed By Terraform" = "true"
  })
}
