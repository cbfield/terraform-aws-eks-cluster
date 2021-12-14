module "my_eks_cluster" {
  source = "../../"

  name = "my-eks-cluster"
  vpc_config = {
    subnet_ids = [
      "subnet-345345",
      "subnet-456456"
    ]
  }

  addons = [
    {
      name    = "vpc-cni"
      version = "1.2.3"
    }
  ]
}
