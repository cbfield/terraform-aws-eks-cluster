resource "aws_cloudwatch_log_group" "this" {
  count = var.create ? 1 : 0

  name = try(var.log_group.name_prefix, null) == null ? coalesce(
    try(var.log_group.name, null),
    "/aws/eks/${var.name}/cluster"
  ) : null

  name_prefix       = try(var.log_group.name_prefix, null)
  retention_in_days = coalesce(try(var.log_group.retention_in_days, null), 7)

  tags = merge(try(var.log_group.tags, {}), {
    "Managed By Terraform" = "true"
  })
}
