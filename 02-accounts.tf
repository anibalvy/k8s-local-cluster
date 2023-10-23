resource "kubernetes_namespace" "jenkins" {
  # depends_on = [aws_eks_cluster.eks]
  # depends_on = [minikube_cluster.kasa-k8s-cluster]
  metadata {
    annotations = { name = "jenkins-env" }
    # labels = { mylabel = "label-value" }
    name = "jenkins"
  }
}

resource "kubernetes_service_account_v1" "jenkins-admin" {
  # depends_on = [kubernetes_secret_v1.jenkins-admin-secret]
    # automount_service_account_token = false
  metadata {
    name      = "jenkins-admin"
    namespace = "jenkins"
  }
  secret {
    # name = "${kubernetes_secret_v1.jenkins-admin.metadata.0.name}" # this doesn't work
        name = "jenkins-admin-token"
  }
}

resource "kubernetes_secret_v1" "jenkins-admin" {
  # depends_on = [kubernetes_namespace.jenkins]
  metadata {
    # name = "jenkins-admin-secret"
    # generate_name = "jenkins-admin-secret-"
    name = "${kubernetes_service_account_v1.jenkins-admin.metadata.0.name}-token"
    namespace = "jenkins"
    annotations = {
      "kubernetes.io/service-account.name" = "jenkins-admin"
    }
  }

  type = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}

resource "kubernetes_cluster_role_binding_v1" "jenkins-admin" {
  # depends_on = [kubernetes_namespace.jenkins]
  metadata {
    name = "jenkins-admin-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"  # this is provide by k8s ClusterRole type
  }
  # subject {
  #   kind      = "User"
  #   name      = "admin"
  #   api_group = "rbac.authorization.k8s.io"
  # }
  subject {
    kind      = "ServiceAccount"
    name      = "jenkins-admin"
    namespace = "jenkins"
  }
  # subject {
  #   kind      = "Group"
  #   name      = "system:masters"
  #   api_group = "rbac.authorization.k8s.io"
  # }
}
