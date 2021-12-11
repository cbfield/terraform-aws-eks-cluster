module "my_eks_cluster" {
  source = "../../"

  name               = "my-eks-cluster"
  kubernetes_version = "1.21"

  vpc_config = {
    subnet_ids = ["subnet-123123", "subnet-234234"]
  }
}
