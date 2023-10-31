
terraform {
  # required_version => ">= 1.0"

  required_providers {
    minikube = {
      source = "scott-the-programmer/minikube"
      version = "0.3.5"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

provider "minikube" {
  # Configuration options
    kubernetes_version =  "v1.27.4"
}



resource "minikube_cluster" "kasa-k8s-cluster" {
    driver       = "kvm2"
    cluster_name = "kasa-k8s-cluster"
    nodes        = 3
    cpus         = 2
    memory       = "4096mb"  # "4g"
    disk_size    = "51200mb" # "50g"
    dns_domain   = "kasa-k8s-cluster"
    # cni          = bridge
    # addons       = [
    # # #                   "dashboard",
    #                     "metrics-server"
    # # #                   "default-storageclass",
    # # #                   "ingress",
    # # #                   "storage-provisioner"
    #                 ]

}

output "cluster_api_ip" {
    value = minikube_cluster.kasa-k8s-cluster.apiserver_ips
    description = "apiserver_ips"
    sensitive = false
}


provider "kubernetes" {
  host                   = minikube_cluster.kasa-k8s-cluster.host
  client_certificate     = minikube_cluster.kasa-k8s-cluster.client_certificate
  client_key             = minikube_cluster.kasa-k8s-cluster.client_key
  cluster_ca_certificate = minikube_cluster.kasa-k8s-cluster.cluster_ca_certificate
}

# provider "kubernetes" {
#   host = "https://104.196.242.174"

#   client_certificate     = "${file("~/.kube/client-cert.pem")}"
#   client_key             = "${file("~/.kube/client-key.pem")}"
#   cluster_ca_certificate = "${file("~/.kube/cluster-ca-cert.pem")}"
# }
provider "kubectl" {
  host                   = minikube_cluster.kasa-k8s-cluster.host
  client_certificate     = minikube_cluster.kasa-k8s-cluster.client_certificate
  client_key             = minikube_cluster.kasa-k8s-cluster.client_key
  cluster_ca_certificate = minikube_cluster.kasa-k8s-cluster.cluster_ca_certificate
  load_config_file = false
}

provider "helm" {
    # kubernetes {
    #     config_path = "~/.kube/config"
    #   }
    kubernetes {
      host                   = minikube_cluster.kasa-k8s-cluster.host
      client_certificate     = minikube_cluster.kasa-k8s-cluster.client_certificate
      client_key             = minikube_cluster.kasa-k8s-cluster.client_key
      cluster_ca_certificate = minikube_cluster.kasa-k8s-cluster.cluster_ca_certificate
   }

}

# provider "helm" {
#   kubernetes {
#     host                   = aws_eks_cluster.demo.endpoint
#     cluster_ca_certificate = base64decode(aws_eks_cluster.demo.certificate_authority[0].data)
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.demo.id]
#       command     = "aws"
#     }
#   }
# }
