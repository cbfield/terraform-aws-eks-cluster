resource "kubernetes_config_map" "aws_auth" {
  count = var.create && coalesce(try(var.aws_auth.create, true), true) ? 1 : 0

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = templatefile("${path.module}/templates/map-roles.yaml.tpl", {
      fargate_roles = concat(
        [
          for fp in var.fargate_profiles : fp.pod_execution_role_arn if fp.pod_execution_role_arn != null
        ],
        [
          for role in [
            try(var.iam.fargate_role.arn, null),
            try(aws_iam_role.fargate_role.0.arn, null)
          ] : role if role != null
        ],
      )
      human_roles = coalesce(try(var.aws_auth.map_roles, null), [])
      node_roles = concat(
        [
          for ng in var.node_groups : ng.node_role_arn if ng.node_role_arn != null
        ],
        [
          for role in [
            try(var.iam.node_role.arn, null),
            try(aws_iam_role.node_role.0.arn, null)
          ] : role if role != null
        ]
      )
    })
    mapUsers = templatefile("${path.module}/templates/map-users.yaml.tpl", {
      users = coalesce(try(var.aws_auth.map_users, null), [])
    })
  }

  depends_on = [aws_eks_cluster.cluster[0]]
}
