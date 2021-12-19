data "aws_eks_cluster_auth" "auth" {
  count = var.create ? 1 : 0

  name = aws_eks_cluster.cluster[0].name
}

data "tls_certificate" "cluster" {
  count = var.create && coalesce(try(var.iam.create_oidc_provider, null), true) ? 1 : 0

  url = aws_eks_cluster.cluster[0].identity[0].oidc[0].issuer
}
