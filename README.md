# terraform-aws-eks-cluster
A Terraform module that creates an Elastic Kubernetes Service (EKS) cluster, with some peripheral resources

# remember

- check default kms key policy, not sure if it will be wide-open or the opposite
- VPC CNI IRSA : https://docs.aws.amazon.com/eks/latest/userguide/cni-iam-role.html
- optional args for EFS, FSX, or EBS?
