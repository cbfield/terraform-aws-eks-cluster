resource "aws_iam_openid_connect_provider" "default" {
  count = coalesce(try(var.iam.create_oidc_provider, null), true) ? 1 : 0

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster[0].certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}
