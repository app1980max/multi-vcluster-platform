
resource "helm_release" "vcluster" {
  name             = var.name
  repository       = "https://charts.loft.sh"
  chart            = "vcluster"
  namespace        = var.namespace
  create_namespace = true

  wait    = true
  timeout = 600

  # Use external values.yaml for all configuration
  values = [file("${path.module}/vcluster-values.yaml")]

  # --- control plane ---
  set {
    name  = "controlPlane.coredns.embedded"
    value = "true"
  }

  # --- sync from host ---
  set {
    name  = "sync.fromHost.ingressClasses.enabled"
    value = "true"
  }

  set {
    name  = "sync.fromHost.nodes.enabled"
    value = "true"
  }

  # --- sync to host ---
  set {
    name  = "sync.toHost.ingresses.enabled"
    value = "true"
  }

  set {
    name  = "sync.toHost.services.enabled"
    value = "true"
  }
}
