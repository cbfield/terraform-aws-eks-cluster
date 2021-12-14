```
module "my_eks_cluster" {
  source = "../../"

  name = "my-eks-cluster"
  vpc_config = {
    subnet_ids = [
      "subnet-345345",
      "subnet-456456"
    ]
  }

  iam = {
    cluster_role = {
      # These adjust the properties of the role created by the module
      managed_policy_arns = ["arn:aws:iam::aws:policy/something"]
      name                = "cluster-123123"
      path                = "/eks/us-east-1/"
    }
    fargate_role = {
      # This tells the module to use a pre-existing role, in which case it will not make its own
      arn = "arn:aws:iam::111222333444:role/something"
    }
    node_role = {
      arn = "arn:aws:iam::111222333444:role/something"
    }
  }
}

```