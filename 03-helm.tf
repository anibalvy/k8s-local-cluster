
resource "helm_release" "secret-manager-store-csi-driver" {
  depends_on       = [minikube_cluster.kasa-k8s-cluster]
  name             = "secret-manager-store-csi-driver"
  repository       = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart            = "secrets-store-csi-driver"
  namespace        = "kube-system"
  wait             = true # wait for the realease to be deployed
}

resource "helm_release" "aws-secret-manager-provider" {
  depends_on       = [minikube_cluster.kasa-k8s-cluster]
  name             = "aws-secret-manager-provider"
  repository       = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  # repository       = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart            = "secrets-store-csi-driver-provider-aws"
  namespace        = "kube-system"
  wait             = true # wait for the realease to be deployed
}

# istio installation
resource "helm_release" "istio-base" {
    depends_on       = [minikube_cluster.kasa-k8s-cluster]
    name             = "istio-base"
    repository       = "https://istio-release.storage.googleapis.com/charts"
    chart            = "base"
    namespace        = "istio-system"
    create_namespace = true
    version          = "1.20.0" # chart version
    # version          = "5.46.8" # chart version
    # timeout          = 600
    wait             = true # wait for the realease to be deployed
    set {
    name  = "global.istioNamespace"
    value = "istio-system"
    }

    # values           = [file("helm/argocd-values.yaml")]
}

resource "helm_release" "istiod" {
    depends_on       = [
                        minikube_cluster.kasa-k8s-cluster,
                        helm_release.istio-base
                       ]
    name             = "istiod"
    repository       = "https://istio-release.storage.googleapis.com/charts"
    chart            = "istiod"
    namespace        = "istio-system"
    create_namespace = true
    version          = "1.20.0" # chart version
    # version          = "5.46.8" # chart version
    # timeout          = 600
    wait             = true # wait for the realease to be deployed

    set {
      name  = "telemetry.enabled"
      value = "true"
    }
    set {
      name  = "global.istioNamespace"
      value = "istio-system"
    }
    set {
      name  = "meshConfig.ingressService"
      value = "istio-gateway"
    }
    set {
      name  = "meshConfig.ingressSelector"
      value = "gateway"
    }

    # values           = [file("helm/argocd-values.yaml")]
}

# helm install argocd -n argocd --create-namespace argo/argo-cd --version 3.35.4 -f terraform/values/argocd.yaml
resource "helm_release" "argocd" {
    depends_on       = [minikube_cluster.kasa-k8s-cluster]
    name             = "argocd"
    repository       = "https://argoproj.github.io/argo-helm"
    chart            = "argo-cd"
    namespace        = "argocd"
    create_namespace = true
    version          = "3.35.4" # chart version
    # version          = "5.46.8" # chart version
    timeout          = 600
    wait             = true # wait for the realease to be deployed

    values           = [file("helm/argocd-values.yaml")]
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


resource "helm_release" "kube-prometheus-stack" {
  depends_on       = [minikube_cluster.kasa-k8s-cluster]
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true
  version          = "54.0.1"
    # wait             = true # wait for the realease to be deployed

  values           = [file("helm/kube-prometheus-stack-values-v54.0.1.yaml")]
}

