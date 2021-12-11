resource "aws_eks_node_group" "node_group" {
  for_each = { for ng in coalesce(var.node_groups, []) : ng.name => ng }

  ami_type               = each.value.ami_type
  capacity_type          = each.value.capacity_type
  cluster_name           = each.value.name
  disk_size              = each.value.disk_size
  force_update_version   = each.value.force_update_version
  instance_types         = each.value.instance_types
  labels                 = each.value.labels
  node_group_name        = each.value.name
  node_group_name_prefix = each.value.name_prefix
  release_version        = each.value.release_version
  version                = each.value.version

  node_role_arn = coalesce(
    each.value.node_role_arn,
    try(aws_iam_role.node_role.0.arn, null),
    try(var.iam.node_role.arn, null)
  )

  subnet_ids = coalesce(
    each.value.subnet_ids,
    var.vpc_config.subnet_ids
  )

  dynamic "launch_template" {
    for_each = each.value.launch_template != null ? [1] : []
    content {
      id      = each.value.launch_template.id
      name    = each.value.launch_template.name
      version = each.value.launch_template.version
    }
  }

  dynamic "remote_access" {
    for_each = each.value.remote_access != null ? [1] : []
    content {
      ec2_ssh_key               = each.value.remote_access.ec2_ssh_key
      source_security_group_ids = each.value.remote_access.source_security_group_ids
    }
  }

  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }

  dynamic "taint" {
    for_each = { for t in coalesce(each.value.taints, []) : "${t.key}:${coalesce(t.value, "novalue")}:${t.effect}" => t }
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  dynamic "update_config" {
    for_each = each.value.update_config != null ? [1] : []
    content {
      max_unavailable            = each.value.update_config.max_unavailable
      max_unavailable_percentage = each.value.update_config.max_unavailable_percentage
    }
  }

  tags = merge(each.value.tags, {
    "Managed By Terraform" = "true"
  })
}
