# terraform-aws-eks-cluster

A Terraform module that creates an Elastic Kubernetes Service (EKS) cluster, with some peripheral resources.

Namely, this module also makes:
- Node groups
- Fargate profiles
- Add-ons
- Identity provider configurations
- Default IAM roles for the cluster itself, its node groups, and its fargate profiles
- A configurable Cloudwatch log group
- A KMS key to encrypt secrets created within the cluster
- Terraform Management of the `aws-auth` configmap within the cluster

### This module declares its own Kubernetes provider

While this module was written to be minimally-opinionated, its one core opinionation is that it declares its own Kubernetes provider (in `_provider.tf`). 

The advantage of this approach is that it enables this module to create the `aws-auth` configmap within the cluster, so kube api access can be managed by Terraform. (A network connection to the Kube API endpoints is required for this)

The disadvantage of this approach is that it disqualifies this module from the usage of the `for_each`, `count`, and `depends_on` meta-arguments. 

I generally consider it "problematic" to entangle the management events of many clusters and rarely need to declare explicit dependencies, so I do not find myself missing those features. You will want to confirm that this is compatible with your Terraform practices before using this module.

# Terraform Docs

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_addon.addon](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_fargate_profile.fargate_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile) | resource |
| [aws_eks_identity_provider_config.identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_identity_provider_config) | resource |
| [aws_eks_node_group.node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_role.cluster_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.fargate_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kms_alias.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [kubernetes_config_map.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [aws_eks_cluster_auth.auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addons"></a> [addons](#input\_addons) | Addons to install in the cluster | <pre>list(object({<br>    name                     = string<br>    resolve_conflicts        = optional(string)<br>    service_account_role_arn = optional(string)<br>    tags                     = optional(map(string))<br>    version                  = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_aws_auth"></a> [aws\_auth](#input\_aws\_auth) | Configurations of the IAM authorizations for this cluster | <pre>object({<br>    create = optional(bool)<br>    map_roles = optional(list(object({<br>      rolearn  = string<br>      username = string<br>      groups   = list(string)<br>    })))<br>    map_users = optional(list(object({<br>      userarn  = string<br>      username = string<br>      groups   = list(string)<br>    })))<br>  })</pre> | `null` | no |
| <a name="input_default_compute_subnet_ids"></a> [default\_compute\_subnet\_ids](#input\_default\_compute\_subnet\_ids) | IDs of subnets to use by default when creating node groups or fargate profiles | `list(string)` | `[]` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | (optional) Log types to be tracked in Cloudwatch (api, audit, authenticator, controllerManager, scheduler) | `list(string)` | `[]` | no |
| <a name="input_encryption_config"></a> [encryption\_config](#input\_encryption\_config) | (optional) Encryption configurations for resources within the cluster | <pre>object({<br>    provider = optional(object({<br>      key_arn = string<br>    }))<br>    resources = optional(list(string))<br>  })</pre> | `null` | no |
| <a name="input_fargate_profiles"></a> [fargate\_profiles](#input\_fargate\_profiles) | (optional) Fargate profiles to create within this EKS cluster | <pre>list(object({<br>    name                   = string<br>    pod_execution_role_arn = optional(string)<br>    subnet_ids             = optional(list(string))<br>    selectors = list(object({<br>      namespace = string<br>      labels    = optional(map(string))<br>    }))<br>    tags = optional(map(string))<br>  }))</pre> | `[]` | no |
| <a name="input_iam"></a> [iam](#input\_iam) | (optional) Configurations for IAM created or used by the module<br>An ARN for an existing IAM role can be provided for the cluster, node groups, or fargate profiles.<br>A role will be created with the necessary permissions for each of them if one wasn't provided.<br>If the role created by the module is used, additional configurations can be provided for it. | <pre>object({<br>    cluster_role = optional(object({<br>      arn                 = optional(string)<br>      managed_policy_arns = optional(list(string))<br>      name                = optional(string)<br>      path                = optional(string)<br>      tags                = optional(map(string))<br>    }))<br>    fargate_role = optional(object({<br>      arn                 = optional(string)<br>      managed_policy_arns = optional(list(string))<br>      name                = optional(string)<br>      path                = optional(string)<br>      tags                = optional(map(string))<br>    }))<br>    node_role = optional(object({<br>      arn                 = optional(string)<br>      managed_policy_arns = optional(list(string))<br>      name                = optional(string)<br>      path                = optional(string)<br>      tags                = optional(map(string))<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_identity_provider_config"></a> [identity\_provider\_config](#input\_identity\_provider\_config) | (optional) IdP config to use with this cluster | <pre>list(object({<br>    oidc = object({<br>      client_id                     = string<br>      groups_claim                  = optional(string)<br>      groups_prefix                 = optional(string)<br>      identity_provider_config_name = string<br>      issuer_url                    = string<br>      required_claims               = optional(map(string))<br>      username_claim                = optional(string)<br>      username_prefix               = optional(string)<br>    })<br>    tags = optional(map(string))<br>  }))</pre> | `[]` | no |
| <a name="input_kubernetes_network_config"></a> [kubernetes\_network\_config](#input\_kubernetes\_network\_config) | (optional) Network configurations for the cluster | <pre>object({<br>    service_ipv4_cidr = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | (optional) The major and minor version of Kubernetes to install in the cluster (X.XX) | `string` | `null` | no |
| <a name="input_log_group"></a> [log\_group](#input\_log\_group) | (optional) Configurations for the Cloudwatch log group created for cluster logs | <pre>object({<br>    name              = optional(string)<br>    name_prefix       = optional(string)<br>    retention_in_days = optional(number)<br>    tags              = optional(map(string))<br>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name assigned to the cluster. Used to prefix other resources created for use by the cluster. | `string` | n/a | yes |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | (optional) Node groups to create within this EKS cluster | <pre>list(object({<br>    ami_type             = optional(string)<br>    capacity_type        = optional(string)<br>    disk_size            = optional(number)<br>    force_update_version = optional(bool)<br>    instance_types       = optional(list(string))<br>    labels               = optional(map(string))<br>    launch_template = optional(object({<br>      id      = optional(string)<br>      name    = optional(string)<br>      version = number<br>    }))<br>    name            = optional(string)<br>    name_prefix     = optional(string)<br>    node_role_arn   = optional(string)<br>    release_version = optional(string)<br>    remote_access = optional(object({<br>      ec2_ssh_key               = optional(string)<br>      source_security_group_ids = optional(list(string))<br>    }))<br>    scaling_config = object({<br>      desired_size = number<br>      max_size     = number<br>      min_size     = number<br>    })<br>    subnet_ids = optional(list(string))<br>    tags       = optional(map(string))<br>    taints = optional(list(object({<br>      key    = string<br>      value  = optional(string)<br>      effect = string<br>    })))<br>    update_config = optional(object({<br>      max_unavailable            = optional(number)<br>      max_unavailable_percentage = optional(number)<br>    }))<br>    version = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (optional) Tags to assign to the cluster | `map(string)` | `null` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configurations for the ENIs created as endpoints for the Kubernetes API for this cluster | <pre>object({<br>    endpoint_private_access = optional(bool)<br>    endpoint_public_access  = optional(bool)<br>    public_access_cidrs     = optional(list(string))<br>    security_group_ids      = optional(list(string))<br>    subnet_ids              = list(string)<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_addons"></a> [addons](#output\_addons) | Addons installed in the cluster |
| <a name="output_aws_auth"></a> [aws\_auth](#output\_aws\_auth) | The value provided for var.aws\_auth |
| <a name="output_cluster"></a> [cluster](#output\_cluster) | The EKS cluster itself |
| <a name="output_cluster_auth"></a> [cluster\_auth](#output\_cluster\_auth) | Kube API auth for the cluster |
| <a name="output_cluster_role"></a> [cluster\_role](#output\_cluster\_role) | The role created for use as the cluster role, if one wasn't provided |
| <a name="output_default_compute_subnet_ids"></a> [default\_compute\_subnet\_ids](#output\_default\_compute\_subnet\_ids) | The value provided for var.default\_compute\_subnet\_ids |
| <a name="output_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#output\_enabled\_cluster\_log\_types) | The value provided for var.enabled\_cluster\_log\_types |
| <a name="output_encryption_key"></a> [encryption\_key](#output\_encryption\_key) | The KMS key created to encrypt objects within the cluster, if one wasn't provided |
| <a name="output_encryption_key_arn"></a> [encryption\_key\_arn](#output\_encryption\_key\_arn) | The KMS alias created for the encryption key, if a key wasn't provided |
| <a name="output_fargate_profiles"></a> [fargate\_profiles](#output\_fargate\_profiles) | Fargate profiles created within the cluster |
| <a name="output_iam"></a> [iam](#output\_iam) | The value provided for var.iam |
| <a name="output_identity_provider_config"></a> [identity\_provider\_config](#output\_identity\_provider\_config) | IdP configurations used by the cluster |
| <a name="output_kubernetes_network_config"></a> [kubernetes\_network\_config](#output\_kubernetes\_network\_config) | The value provided for var.kubernetes\_network\_config |
| <a name="output_kubernetes_version"></a> [kubernetes\_version](#output\_kubernetes\_version) | The value provided for var.kubernetes\_version |
| <a name="output_log_group"></a> [log\_group](#output\_log\_group) | The Cloudwatch log group created for cluster logs |
| <a name="output_name"></a> [name](#output\_name) | The value provided for var.name |
| <a name="output_node_groups"></a> [node\_groups](#output\_node\_groups) | Node groups created within the cluster |
| <a name="output_tags"></a> [tags](#output\_tags) | Tags assigned to the cluster |
| <a name="output_vpc_config"></a> [vpc\_config](#output\_vpc\_config) | The value provided for var.vpc\_config |
