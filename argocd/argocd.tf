## Create a namespace for argocd
#resource "kubernetes_namespace" "argocd" {
#  count = var.create_argocd ? 1 : 0
#  metadata {
#    name = "argocd"
#  }
#}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.5.2"
  namespace        = "argocd"
  create_namespace = true
  values = [
    file("${path.module}/argocd-values.yaml")
  ]
}

#resource "aws_route53_record" "argocd_lb" {
#  count   = var.create_argcd_dns_record && var.create_argocd ? 1 : 0
#  zone_id = aws_route53_zone.created_public_zone[var.argocd_hosted_zone_id].id
#  name    = var.argocd_server_addr # "argocd.stg.kto.com" "# "argocd.dev.kto.com""
#  ttl     = "300"
#  type    = "CNAME"
#  records = [data.kubernetes_service.argocd_server[0].status.0.load_balancer.0.ingress.0.hostname]
#}