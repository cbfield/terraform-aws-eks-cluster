resource "aws_cloudwatch_log_group" "logs" {
  name = try(var.log_group.name_prefix, null) == null ? (
    coalesce(try(var.log_group.name, null), "/aws/eks/${var.name}/cluster")
  ) : null
  name_prefix       = try(var.log_group.name_prefix, null)
  retention_in_days = coalesce(try(var.log_group.retention_in_days, null), 7)

  tags = merge(try(var.log_group.tags, null), {
    "Managed By Terraform" = "true"
  })
}
