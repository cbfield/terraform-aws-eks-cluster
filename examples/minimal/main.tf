module "my_eks_cluster" {
  source = "../../"

  name               = "my-eks-cluster"
  kubernetes_version = "1.21"

  vpc_config = {
    subnet_ids = ["subnet-9e110eb6", "subnet-2c596c55"]
  }
}
