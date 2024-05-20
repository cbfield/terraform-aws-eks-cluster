resource "aws_kms_key" "this" {
  count = var.create && try(var.encryption_config.provider.key_arn, null) == null ? 1 : 0

  description = "Encrypts the contents of the EKS cluster ${var.name}"

  tags = {
    "EKS Cluster" = var.name
  }
}

resource "aws_kms_alias" "this" {
  count = var.create && try(var.encryption_config.provider.key_arn, null) == null ? 1 : 0

  name          = "alias/eks-${var.name}"
  target_key_id = aws_kms_key.this[0].arn
}
