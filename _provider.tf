provider "kubernetes" {
  host                   = try(aws_eks_cluster.cluster[0].endpoint, "https://jsonplaceholder.typicode.com")
  cluster_ca_certificate = try(base64decode(aws_eks_cluster.cluster[0].certificate_authority[0]["data"]), "")
  token                  = try(data.aws_eks_cluster_auth.auth[0].token, "")
}
