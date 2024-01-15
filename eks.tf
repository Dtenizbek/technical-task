provider "aws" {
  region  = "us-east-1"
  version = "5.3.1"
}

data "aws_caller_identity" "current" {}

variable "vpc_id" {}
variable "subnet_ids" {}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.28"  

  subnets = var.subnet_ids
  vpc_id  = var.vpc_id
}

resource "aws_iam_role" "eks_node_group" {
  name = "eks-node-group"

  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [{
      Effect: "Allow",
      Principal: { Service: "ec2.amazonaws.com" },
      Action: "sts:AssumeRole"
    }]
  })

  tags = {
    Name        = "EKSNodeGroupRole"
    Environment = "Production"
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.eks_node_group.arn]
  }
}

resource "aws_iam_policy" "pod_assume_role_policy" {
  name        = "pod-assume-role-policy"
  description = "Policy allowing pods to assume the EKS node group IAM role"
  policy      = data.aws_iam_policy_document.assume_role_policy.json
}


output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "eks_cluster_security_group_ids" {
  value = module.eks.cluster_security_group_ids
}

output "eks_cluster_subnet_ids" {
  value = module.eks.cluster_subnet_ids
}
