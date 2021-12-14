%{ if length(concat(node_roles, fargate_roles, human_roles)) > 0 ~}
%{ for node_role in node_roles ~}
- groups:
  - system:bootstrappers
  - system:nodes
  rolearn: ${node_role}
  username: system:node:{{EC2PrivateDNSName}}
%{ endfor ~}
%{ for fargate_role in fargate_roles ~}
- groups:
  - system:bootstrappers
  - system:node-proxier
  - system:nodes
  rolearn: ${fargate_role}
  username: system:node:{{SessionName}}
%{ endfor ~}
%{ for human_role in human_roles ~}
- groups: %{ if human_role.groups == [] ~}[]%{ endif ~}
%{ for group in human_role.groups }
  - ${group}
%{ endfor ~}
  rolearn: ${human_role.rolearn}
  username: ${human_role.username}
%{ endfor ~}
%{ else ~}
[]
%{ endif ~}
