data "aws_eks_cluster_auth" "auth" {
  name = aws_eks_cluster.cluster.name
}
