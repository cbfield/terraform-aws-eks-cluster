variable "access_config" {
  type = object({
    authentication_mode = optional(string)
    bootstrap_cluster_creator_admin_permissions = optional(bool)
  })
  default = {}
}

variable "access_entries" {
  type = list(object({
    principal_arn = string
    k8s_groups    = optional(list(string), [])
    type          = optional(string, "STANDARD")
    tags          = optional(map(string))
    user_name     = optional(string)
    policy_associations = optional(list(object({
      policy_arn       = string
      scope_type       = string
      scope_namespaces = optional(list(string))
    })), [])
  }))
  default = []
}

variable "addons" {
  description = "Addons to install in the cluster"
  type = list(object({
    name                     = string
    service_account_role_arn = optional(string)
    tags                     = optional(map(string))
    version                  = optional(string)
  }))
  default = []
}

variable "create" {
  description = "This can be used to enable or disable creation of all resources by the module"
  type        = bool
  default     = true
}

variable "default_compute_subnet_ids" {
  description = "Subnet IDs to use by default when creating node groups or fargate profiles"
  type        = list(string)
  default     = []
}

variable "enabled_cluster_log_types" {
  description = "Log types to be tracked in Cloudwatch (api, audit, authenticator, controllerManager, scheduler)"
  type        = list(string)
  default     = []
}

variable "encryption_config" {
  description = "Encryption configurations for resources within the cluster"
  type = object({
    provider = optional(object({
      key_arn = string
    }))
    resources = optional(list(string))
  })
  default = null
}

variable "fargate_profiles" {
  description = "Fargate profiles to create within the cluster"
  type = list(object({
    name                   = string
    pod_execution_role_arn = optional(string)
    subnet_ids             = optional(list(string)) //takes precedence over var.default_compute_subnet_ids
    selectors = list(object({
      namespace = string
      labels    = optional(map(string))
    }))
    tags = optional(map(string))
  }))
  default = []
}

variable "iam" {
  description = <<-EOF
    Configurations for IAM resources created or used by the module
    An ARN for an existing IAM role can be provided for the cluster, node groups, or fargate profiles.
    A role will be created with the necessary permissions for each of them if one wasn't provided.
    If the role created by the module is used, additional configurations can be provided for it.
    EOF
  type = object({
    cluster_role = optional(object({
      arn                 = optional(string)
      managed_policy_arns = optional(list(string))
      name                = optional(string)
      path                = optional(string)
      tags                = optional(map(string))
    }))
    create_oidc_provider = optional(bool)
    fargate_role = optional(object({
      arn                 = optional(string)
      managed_policy_arns = optional(list(string))
      name                = optional(string)
      path                = optional(string)
      tags                = optional(map(string))
    }))
    node_role = optional(object({
      arn                 = optional(string)
      managed_policy_arns = optional(list(string))
      name                = optional(string)
      path                = optional(string)
      tags                = optional(map(string))
    }))
  })
  default = {}
}

variable "identity_provider_config" {
  description = "IdP config to use with this cluster"
  type = list(object({
    oidc = object({
      client_id                     = string
      groups_claim                  = optional(string)
      groups_prefix                 = optional(string)
      identity_provider_config_name = string
      issuer_url                    = string
      required_claims               = optional(map(string))
      username_claim                = optional(string)
      username_prefix               = optional(string)
    })
    tags = optional(map(string))
  }))
  default = []
}

variable "kubernetes_network_config" {
  description = "Network configurations for the cluster"
  type = object({
    service_ipv4_cidr = optional(string)
  })
  default = null
}

variable "kubernetes_version" {
  description = "The major and minor version of Kubernetes to install in the cluster (X.XX)"
  type        = string
  default     = null
}

variable "log_group" {
  description = "Configurations for the Cloudwatch log group created for cluster logs"
  type = object({
    name              = optional(string)
    name_prefix       = optional(string)
    retention_in_days = optional(number)
    tags              = optional(map(string))
  })
  default = null
}

variable "name" {
  description = "The name assigned to the cluster. Used to prefix other resources created for use by the cluster."
  type        = string
}

variable "node_groups" {
  description = "Node groups to create within this EKS cluster"
  type = list(object({
    ami_type             = optional(string)
    capacity_type        = optional(string)
    disk_size            = optional(number)
    force_update_version = optional(bool)
    instance_types       = optional(list(string))
    labels               = optional(map(string))
    launch_template = optional(object({
      id      = optional(string)
      name    = optional(string)
      version = number
    }))
    name            = optional(string)
    name_prefix     = optional(string)
    node_role_arn   = optional(string)
    release_version = optional(string)
    remote_access = optional(object({
      ec2_ssh_key               = optional(string)
      source_security_group_ids = optional(list(string))
    }))
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
    subnet_ids = optional(list(string))
    tags       = optional(map(string))
    taints = optional(list(object({
      key    = string
      value  = optional(string)
      effect = string
    })))
    update_config = optional(object({
      max_unavailable            = optional(number)
      max_unavailable_percentage = optional(number)
    }))
    version = optional(string)
  }))
  default = []
}

variable "tags" {
  description = "Tags to assign to the cluster"
  type        = map(string)
  default     = null
}

variable "vpc_config" {
  description = "Configurations for the cluster's endpoint ENIs"
  type = object({
    endpoint_private_access = optional(bool)
    endpoint_public_access  = optional(bool)
    public_access_cidrs     = optional(list(string))
    security_group_ids      = optional(list(string))
    subnet_ids              = list(string)
  })
}
