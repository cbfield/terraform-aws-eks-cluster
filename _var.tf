variable "enabled_cluster_log_types" {
  description = "(optional) Log types to be tracked in Cloudwatch (api, audit, authenticator, controllerManager, scheduler)"
  type        = list(string)
  default     = null
}

variable "encryption_config" {
  description = "(optional) Encryption configurations for resources within the cluster"
  type = object({
    provider = optional(object({
      key_arn = string
    }))
    resources = optional(list(string))
  })
  default = null
}

variable "fargate_profiles" {
  description = "(optional) Fargate profiles to create within this EKS cluster"
  type = list(object({
    name                   = string
    pod_execution_role_arn = optional(string)
    subnet_ids             = optional(list(string))
    selectors = list(object({
      namespace = string
      labels    = optional(map(string))
    }))
    tags = optional(map(string))
  }))
  default = null
}

variable "iam" {
  description = <<-EOF
    (optional) Configurations for IAM created or used by the module
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
  default = null
}

variable "kubernetes_network_config" {
  description = "(optional) Network configurations for the cluster"
  type = object({
    service_ipv4_cidr = optional(string)
  })
  default = null
}

variable "kubernetes_version" {
  description = "(optional) The major and minor version of Kubernetes to install in the cluster (X.XX)"
  type        = string
  default     = null
}

variable "name" {
  description = "The name assigned to the cluster. Used to prefix other resources created for use by the cluster."
  type        = string
}

variable "node_groups" {
  description = "(optional) Node groups to create within this EKS cluster"
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
    scaling_config = optional(object({
      desired_size = number
      max_size     = number
      min_size     = number
    }))
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
  default = null
}

variable "tags" {
  description = "(optional) Tags to assign to the cluster"
  type        = map(string)
  default     = null
}

variable "vpc_config" {
  description = "Configurations for the ENIs created as endpoints for the Kubernetes API for this cluster"
  type = object({
    endpoint_private_access = optional(bool)
    endpoint_public_access  = optional(bool)
    public_access_cidrs     = optional(list(string))
    security_group_ids      = optional(list(string))
    subnet_ids              = list(string)
  })
}
