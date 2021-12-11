resource "aws_kms_key" "key" {
  count = try(var.encryption_config.provider.key_arn, null) != null ? 0 : 1

  description = "Encrypts objects in EKS cluster ${var.name}"

  tags = {
    "Encrypted Resource Types" = join(",", coalesce(try(var.encryption_config.resources, null), ["secrets"]))
    "EKS Cluster Name"         = var.name
    "Managed By Terraform"     = "true"
  }
}

resource "aws_kms_alias" "alias" {
  count = try(var.encryption_config.provider.key_arn, null) != null ? 0 : 1

  name          = "alias/eks-${var.name}"
  target_key_id = aws_kms_key.key.0.arn
}
