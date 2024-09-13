locals {
  environment  = "staging"
  cluster_name = "staging-eks"
  region      = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.66.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.15.0"
    }
  }
}

data "aws_eks_cluster" "default" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "default" {
  name = local.cluster_name
}

provider "aws" {
  profile = "dpe-${local.environment}"
  region  = local.region
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.default.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.default.token
  }
}

data "kubernetes_service" "argocd_server" {
  count = var.create_argcd_dns_record && var.create_argocd ? 1 : 0
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }
}