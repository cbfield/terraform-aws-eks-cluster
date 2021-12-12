resource "kubernetes_config_map" "aws_auth" {
  count = try(var.aws_auth.create, true) == true && (
    length(concat(
      var.node_groups,
      var.fargate_profiles,
      try(var.aws_auth.map_roles, [])
    )) > 0
  ) ? 1 : 0

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(flatten([
      # Human Roles
      try(var.aws_auth.map_roles, []),
      # Node Group Roles
      [
        for node_role_arn in flatten([
          try(var.iam.node_role.arn, []),
          try(aws_iam_role.node_role.0.arn, []),
          [for ng in var.node_groups : ng.node_role_arn],
          ]) : {
          role_arn = node_role_arn
          username = "system:node:{{EC2PrivateDNSName}}"
          groups   = ["system:nodes", "system:bootstrappers"]
        }
      ],
      # Fargate Profile Roles
      [
        for fargate_role_arn in flatten([
          try(var.iam.fargate_role.arn, []),
          try(aws_iam_role.fargate_role.0.arn, []),
          [for fp in var.fargate_profiles : fp.pod_execution_role_arn],
          ]) : {
          role_arn = fargate_role_arn
          username = "system:node:{{SessionName}}"
          groups   = ["system:bootstrappers", "system:node-proxier", "system:nodes"]
        }
      ],
    ]))
  }

  depends_on = [aws_eks_cluster.cluster]
}
