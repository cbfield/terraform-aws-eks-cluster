module "my_eks_cluster" {
  source = "../../"

  name               = "my-eks-cluster"
  kubernetes_version = "1.21"

  vpc_config = {
    subnet_ids = ["subnet-123123", "subnet-234234"]
  }

  # node_groups = [
  #   {
  #     name = "default"
  #     scaling_config = {
  #       desired_size = 5
  #       max_size     = 1
  #       min_size     = 1
  #     }
  #   }
  # ]

  # iam = {
  #   cluster_role = {
  #     arn                 = "arn:aws:iam::111222333444:role/your-mom"
  #     managed_policy_arns = ["arn:aws:iam::aws:policy/potato"]
  #     name                = "your-mom"
  #     path                = "/eks/us-east-1/"
  #   }
  #   node_role = {
  #     arn = "arn:aws:iam::111222333444:role/your-mom"
  #   }
  # }

  # kubernetes_network_config = {
  #   service_ipv4_cidr = "10.20.0.0/16"
  # }
}
