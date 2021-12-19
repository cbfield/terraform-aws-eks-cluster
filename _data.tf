data "aws_eks_cluster_auth" "auth" {
  name = aws_eks_cluster.cluster.name
}

data "tls_certificate" "cluster" {
  count = coalesce(try(var.iam.create_oidc_provider, null), true) ? 1 : 0

  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}
