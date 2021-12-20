provider "kubernetes" {
  host                   = try(aws_eks_cluster.cluster[0].endpoint, "https://jsonplaceholder.typicode.com")
  cluster_ca_certificate = try(base64decode(aws_eks_cluster.cluster[0].certificate_authority[0]["data"]), "")

  token = coalesce(try(var.aws_auth.method, null), "exec") == "token" ? try(
    data.aws_eks_cluster_auth.auth[0].token, ""
  ) : null

  dynamic "exec" {
    for_each = coalesce(try(var.aws_auth.method, null), "exec") == "exec" ? [1] : []
    content {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.name]
      command     = coalesce(try(var.aws_auth.exec_path, null), "/usr/local/bin/aws")
    }
  }
}
