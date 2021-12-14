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
