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
# resource "kubernetes_manifest" "argocd-go-api-secret" {
#   manifest = yamldecode(file("deployments/go-skel-api/01-configmap.yaml"))
# }
# resource "kubernetes_manifest" "argocd-go-api" {
#   depends_on = [
#     minikube_cluster.kasa-k8s-cluster,
#     helm_release.argocd
#   ]

#   manifest = yamldecode(file("argocd/go-skel-api-app.yaml"))
# }
# GO-API
resource "kubectl_manifest" "argocd-go-api-ns" {
  yaml_body = file("deployments/go-skel-api/00-namespace.yaml")
  depends_on = [
    minikube_cluster.kasa-k8s-cluster
  ]
}
resource "kubectl_manifest" "argocd-go-api-secret" {
  yaml_body = file("deployments/go-skel-api/01-configmap.yaml")
  depends_on = [
    minikube_cluster.kasa-k8s-cluster,
    kubectl_manifest.argocd-go-api-ns
  ]
}

resource "kubectl_manifest" "argocd-go-api" {
  yaml_body = file("argocd/go-skel-api-app.yaml")
  depends_on = [
    minikube_cluster.kasa-k8s-cluster,
    helm_release.argocd,
    kubectl_manifest.argocd-go-api-secret
  ]
}
