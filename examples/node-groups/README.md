```
# Default subnets
module "my_eks_cluster" {
  source = "../../"

  name = "my-eks-cluster"
  vpc_config = {
    subnet_ids = [
      "subnet-345345",
      "subnet-456456"
    ]
  }

  default_compute_subnet_ids = [
    "subnet-345345",
    "subnet-456456",
  ]

  node_groups = [
    {
      name = "node-group-1"
      ami  = data.aws_ami.amazon_linux_2.id
      remote_access = {
        ec2_ssh_key = "devops-admin" # name of the ec2 keypair
        source_security_group_ids = [
          "sg-123123"
        ]
      }
      scaling_config = {
        desired_size = 1
        max_size     = 3
        min_size     = 1
      }
    },
    {
      name          = "node-group-2"
      ami_type      = "BOTTLEROCKET_x86_64"
      node_role_arn = "arn:aws:iam::111222333444:role/something"
      subnet_ids = [
        "subnet-789789",
        "subnet-987987",
      ]
      scaling_config = {
        desired_size = 5
        max_size     = 10
        min_size     = 1
      }
    }
  ]
}

```