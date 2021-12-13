module "my_eks_cluster" {
  source = "../../"

  name               = "my-eks-cluster"
  kubernetes_version = "1.21"

  vpc_config = {
    endpoint_public_access = true
    subnet_ids = [
      "subnet-123123",
      "subnet-234234",
    ]
  }

  default_compute_subnet_ids = [
    "subnet-345345",
    "subnet-456456",
  ]

  aws_auth = {
    map_roles = [{
      rolearn  = "arn:aws:iam::111222333444:role/devops-admin"
      username = "devops-admin"
      groups   = ["system:masters"]
    }]
  }

  node_groups = [
    {
      name = "default"
      scaling_config = {
        desired_size = 1
        max_size     = 3
        min_size     = 1
      }
    }
  ]

  fargate_profiles = [
    {
      name      = "default"
      selectors = [{ namespace = "default" }]
    }
  ]

  iam = {
    cluster_role = {
      arn                 = "arn:aws:iam::111222333444:role/something"
      managed_policy_arns = ["arn:aws:iam::aws:policy/something"]
      name                = "cluster-123123"
      path                = "/eks/us-east-1/"
    }
    fargate_role = {
      arn = "arn:aws:iam::111222333444:role/something"
    }
    node_role = {
      arn = "arn:aws:iam::111222333444:role/something"
    }
  }

  kubernetes_network_config = {
    service_ipv4_cidr = "10.20.0.0/16"
  }

  addons = [{ name = "vpc-cni" }]
}
