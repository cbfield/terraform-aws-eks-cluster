module "eks_cluster" {
  source = "../../"

  # required arguments
  name = "my-eks-cluster"

  vpc_config = {
    subnet_ids = ["subnet-123123", "subnet-234234"]
  }
}
