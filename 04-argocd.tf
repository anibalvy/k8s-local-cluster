# resource "kubernetes_manifest" "app-01" {
#   # manifest = {....}
#   manifest = [file("argo/app-01.yaml")]
# }


# resource "kubernetes_manifest" "metrics-server" {
#   # manifest = {....}
#   # manifest = templatefile("$(argocd/metrics-server.yaml)"]
#   manifest = yamldecode(file("argocd/metrics-server.yaml"))
# }

# resource "kubectl_manifest" "metrics-server" {
#   yaml_body = file("argocd/metrics-server.yaml")
# }

# install go api
resource "kubernetes_manifest" "argocd-go-api" {
  manifest = yamldecode(file("argocd/go-skel-api-app.yaml"))
}

