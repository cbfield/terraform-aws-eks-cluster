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

  addons = [
    {
      name    = "vpc-cni"
      version = "1.2.3"
    }
  ]

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

  fargate_profiles = [
    {
      name = "profile-1"
      selectors = [
        { namespace = "app-1" }
      ]
      subnet_ids = [
        "subnet-543534",
        "subnet-312312",
      ]
    },
    {
      name = "profile-2"
      selectors = [
        {
          namespace = "app-2"
          labels = {
            app       = "my-app"
            component = "my-component"
          }
        }
      ]
    }
  ]
}

```