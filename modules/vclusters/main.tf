
resource "helm_release" "vcluster" {
  name             = var.name
  repository       = "https://charts.loft.sh"
  chart            = "vcluster"
  namespace        = var.namespace
  create_namespace = true
}

resource "null_resource" "register" {

  provisioner "local-exec" {

    environment = {
      LOFT_HOST     = var.loft_host
      LOFT_USERNAME = var.loft_user
      LOFT_PASSWORD = var.loft_password
      KUBECONFIG    = var.kubeconfig_path
    }

    command = <<EOT
set -e
echo "Checking cluster ${var.name} in Loft..."
if loft cluster get ${var.name} --project "${var.loft_project}" &> /dev/null; then
  echo "Cluster ${var.name} already registered in Loft"
else
  echo "Registering cluster ${var.name} in Loft project ${var.loft_project}"

  loft cluster add \
    --name ${var.name} \
    --namespace ${var.namespace} \
    --project "${var.loft_project}"
fi
EOT
  }

  depends_on = [helm_release.vcluster]
}
