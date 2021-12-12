module "my_eks_cluster" {
  source = "../../"

  name               = "my-eks-cluster"
  kubernetes_version = "1.21"

  vpc_config = {
    subnet_ids = ["subnet-9e110eb6", "subnet-2c596c55"]
  }

  aws_auth = {
    map_roles = [{
      role_arn = "arn:aws:iam::111222333444:role/devops-admin"
      username = "devops-admin"
      groups   = ["system:masters"]
    }]
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

  # fargate_profiles = [
  #   {
  #     name      = "default"
  #     selectors = [{ namespace = "default" }]
  #   }
  # ]

  # iam = {
  #   cluster_role = {
  #     arn                 = "arn:aws:iam::111222333444:role/devops-admin"
  #     managed_policy_arns = ["arn:aws:iam::aws:policy/something"]
  #     name                = "devops-admin"
  #     path                = "/eks/us-east-1/"
  #   }
  #   fargate_role = {
  #     arn = "arn:aws:iam::111222333444:role/devops-admin"
  #   }
  # node_role = {
  #   arn = "arn:aws:iam::111222333444:role/devops-admin"
  # }
  # }

  # kubernetes_network_config = {
  #   service_ipv4_cidr = "10.20.0.0/16"
  # }

  # addons = [{ name = "vpc-cni" }]
}
