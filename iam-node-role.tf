resource "aws_iam_role" "node_role" {
  count = var.create && try(var.iam.node_role.arn, null) == null && anytrue([
    for ng in var.node_groups : ng.node_role_arn == null
  ]) ? 1 : 0

  description = "Default role for node groups of the EKS cluster ${var.name}"
  name        = try(var.iam.node_role.name, "eks-${var.name}-nodes")
  path        = try(var.iam.node_role.path, null)

  assume_role_policy = templatefile(
    "${path.module}/templates/assume-role-policy.json.tpl", {
      service = "ec2"
    }
  )

  managed_policy_arns = coalesce(try(var.iam.node_role.managed_policy_arns, null), [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
  ])

  tags = merge(try(var.iam.node_role.tags, {}), {
    "Managed By Terraform" = "true"
  })
}
