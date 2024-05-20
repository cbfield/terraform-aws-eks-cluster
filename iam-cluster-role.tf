resource "aws_iam_role" "cluster_role" {
  count = var.create && try(var.iam.cluster_role.arn, null) == null ? 1 : 0

  description = "Role used by the EKS cluster ${var.name}"
  name        = coalesce(try(var.iam.cluster_role.name, null), "eks-${var.name}-cluster")
  path        = try(var.iam.cluster_role.path, null)
  tags        = try(var.iam.cluster_role.tags,null)

  assume_role_policy = templatefile(
    "${path.module}/templates/assume-role-policy.json.tpl", {
      service = "eks"
    }
  )

  managed_policy_arns = coalesce(
    try(var.iam.cluster_role.managed_policy_arns, null),
    ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
  )
}
