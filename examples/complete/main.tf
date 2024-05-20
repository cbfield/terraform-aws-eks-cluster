module "eks_cluster" {
  source = "../../"

  # required arguments
  name = "my-eks-cluster"

  vpc_config = {
    endpoint_private_access = true                               # optional
    endpoint_public_access  = true                               # optional
    public_access_cidrs     = ["0.0.0.0/0"]                      # optional
    security_group_ids      = ["sg-123123"]                      # optional
    subnet_ids              = ["subnet-123123", "subnet-234234"] # required
  }

  # optional arguments
  access_entries = [
    for role_arn in data.aws_iam_roles.aws_sso_admin.arns : {
      principal_arn = role_arn                                          # required
      k8s_groups    = ["my_group"]                                      # optional
      type          = "STANDARD"                                        # optional
      tags          = { "tag1" = "value" }                              # optional
      user_name     = "timmy"                                           # optional
      policy_associations = [{                                          # optional
        policy_arn       = "arn:aws:iam::000000000000:policy/my-policy" # required
        scope_namespaces = ["namespace1", "namespace2"]                 # optional, valid only for "namespace" type
        scope_type       = "namespace"                                  # optional, "namespace" or "cluster"
      }]
    }
  ]

  addons = [
    {
      name                     = "vpc-cni"                                # required
      service_account_role_arn = "arn:aws:iam::000000000000:role/my-role" # optional
      tags                     = { "my-tag" = "something" }               # optional
      version                  = "v1.2.3"                                 # optional
    }
  ]

  create = true # use to toggle the entire module off and on

  default_compute_subnet_ids = ["subnet-345345", "subnet-45456"]

  enabled_cluster_log_types = ["api", "audit"]

  encryption_config = {
    resources = ["secrets"]
    provider = {
      key_arn = "arn:aws:kms:us-west-2:000000000000:key/00000000-0000-0000-0000-000000000000"
    }
  }

  fargate_profiles = [
    {
      name                   = "profile-1"                              # required
      pod_execution_role_arn = "arn:aws:iam::000000000000:role/my-role" # optional, will be used instead of var.iam.fargate_role
      subnet_ids             = ["subnet-567567", "subnet-678678"]       # optional, takes precedence over var.default_compute_subnet_ids
      selectors = [
        {
          namespace = "my-namespace"
          labels = {
            "label1" = "value"
            "label2" = "value"
          }
        }
      ]
      tags = {
        "tag1" = "value"
      }
    }
  ]

  iam = {
    cluster_role = {
      arn                 = "arn:aws:iam::000000000000:role/my-role" # optional, will be used instead of creating a role
      managed_policy_arns = ["arn:aws:..."]                          # optional
      name                = "my-cluster-role"                        # required
      path                = "/eks/"                                  # optional
      tags                = { "tag1" = "value" }                     # optional
    }
    fargate_role = {
      arn                 = "arn:aws:iam::000000000000:role/my-role" # optional, will be used instead of creating a role
      managed_policy_arns = ["arn:aws:..."]                          # optional
      name                = "my-fargate-role"                        # required
      path                = "/eks/"                                  # optional
      tags                = { "tag1" = "value" }                     # optional
    }
    node_role = {
      arn                 = "arn:aws:iam::000000000000:role/my-role" # optional, will be used instead of creating a role
      managed_policy_arns = ["arn:aws:..."]                          # optional
      name                = "my-node-role"                           # required
      path                = "/eks/"                                  # optional
      tags                = { "tag1" = "value" }                     # optional
    }
  }

  identity_provider_config = [
    {
      oidc = {
        client_id                     = "value"                 # required
        groups_claim                  = "value"                 # optional
        groups_prefix                 = "value"                 # optional
        identity_provider_config_name = "value"                 # required
        issuer_url                    = "https://something.com" # required
        required_claims               = { "claim1" = "value" }  # optional
        username_claim                = "value"                 # optional
        username_prefix               = "value"                 # optional
      }
      tags = { "tag1" = "value" } # optional
    }
  ]

  kubernetes_network_config = {
    service_ipv4_cidr = "10.0.0.0/12"
  }

  kubernetes_version = "1.23"

  log_group = {
    name              = "value"              # optional, conflicts with var.log_group.name_prefix
    name_prefix       = "value"              # optional, conflicts with var.log_group.name
    retention_in_days = 7                    # optional
    tags              = { "tag1" = "value" } # optional
  }

  node_groups = [
    {
      name = "node-group-1" # optional, conflicts with name_prefix
      # name_prefix        = "node-group-1"                 # optional, conflicts with name
      ami                  = data.aws_ami.amazon_linux_2.id # required
      ami_type             = "AL2_x86_64"                   # optional, https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType
      capacity_type        = "ON_DEMAND"                    # optional
      force_update_version = true                           # optional
      instance_types       = ["t3.medium"]                  # optional
      labels               = { "name" = "value" }           # optional
      launch_template = {                                   # optional
        id = "lt-123123"                                    # optional, conflicts with name
        # name  = "value"                                   # optional, conflicts with id
        version = 1
      }
      node_role_arn   = "arn:aws:iam::000000000000:role/my-role" # optional
      release_version = "value"                                  # optional
      remote_access = {                                          # optional
        ec2_ssh_key               = "value"                      # required
        source_security_group_ids = ["sg-123"]                   # optional
      }
      scaling_config = { # required
        desired_size = 1
        max_size     = 3
        min_size     = 1
      }
      subnet_ids = ["subnet-123123", "subnet-234234"] # optional, takes precedence over var.default_compute_subnet_ids
      tags       = { "tag1" = "value" }               # optional
      taints = [{                                     # optional
        effect = "NO_SCHEDULE"
        key    = "value"
      }]
      update_config = {     # optional
        max_unavailable = 1 # optional, conflicts with max_unavailable_percentage
        # max_unavailable_percentage = 0 # optional, conflicts with max_unavailable
      }
      version = "value" # optional
    }
  ]

  tags = {
    "tag1" = "value"
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_iam_roles" "aws_sso_admin" {
  name_regex  = "AWSReservedSSO_AWSAdministratorAccess_.*"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}
