# helm install argocd -n argocd --create-namespace argo/argo-cd --version 3.35.4 -f terraform/values/argocd.yaml

resource "helm_release" "argocd" {
    name             = "argocd"
    repository       = "https://argoproj.github.io/argo-helm"
    chart            = "argo-cd"
    namespace        = "argocd"
    create_namespace = true
    # version          = "3.35.4" # chart version
    version          = "5.46.8" # chart version
    timeout          = 600

    values           = [file("helm/argocd-defaults-5.49.0.yaml")]
}
 # on tf apply its possible to see deployment with:
 # helm status argocd -n argocd


# resource "helm_release" "metrics-server" {
#     name             = "metrics-server"
#     repository       = "https://kubernetes-sigs.github.io/metrics-server/"
#     chart            = "metrics-server"
#     namespace        = "monitoring"
#     create_namespace = true
#     version          = "3.11.0" # chart version
#     timeout          = 600

#     wait             = true # wait for the realease to be deployed

#     values           = [file("helm/metrics-server-values.yaml")]
# }


# resource "helm_release" "prometheus_operator_crds" {
#   name = "prometheus-operator-crds"

#   repository       = "https://prometheus-community.github.io/helm-charts"
#   chart            = "prometheus-operator-crds"
#   namespace        = "monitoring"
#   create_namespace = true
#   version          = "6.0.0"
# }
