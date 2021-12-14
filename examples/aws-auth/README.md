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

  aws_auth = {
    map_roles = [
      {
        rolearn  = "arn:aws:iam::111222333444:role/devops-admin"
        username = "devops-admin"
        groups   = ["system:masters"]
      },
      {
        rolearn  = "arn:aws:iam::111222333444:role/app1-admin"
        username = "app1-admin"
        groups   = ["app1-admin"]
      },
    ]
  }
}

```
