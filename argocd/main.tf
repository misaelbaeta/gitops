provider "aws" {
  region = var.AWS_REGION
}


locals {
  cluster_name = "sre"
  region       = "us-east-1"
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

  backend "s3" {
    bucket = "sre-us-east-1"
    key    = "argocd/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_eks_cluster" "sre" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "sre" {
  name = local.cluster_name
}


provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.sre.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.sre.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.sre.token
  }
}

#data "kubernetes_service" "argocd_server" {
#  count = var.create_argcd_dns_record && var.create_argocd ? 1 : 0
#  metadata {
#    name      = "argocd-server"
#    namespace = "argocd"
#  }
#}