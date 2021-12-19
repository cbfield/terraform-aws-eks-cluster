resource "aws_kms_key" "key" {
  count = var.create && try(var.encryption_config.provider.key_arn, null) == null ? 1 : 0

  description = "Encrypts the contents of the EKS cluster ${var.name}"

  tags = {
    "EKS Cluster"          = var.name
    "Managed By Terraform" = "true"
  }
}

resource "aws_kms_alias" "alias" {
  count = var.create && try(var.encryption_config.provider.key_arn, null) == null ? 1 : 0

  name          = "alias/eks-${var.name}"
  target_key_id = aws_kms_key.key[0].arn
}
