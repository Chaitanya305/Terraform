resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region us-east-1 --name ${aws_eks_cluster.eks-cluster.name}"
  }
  #depends_on = [aws_eks_cluster.eks-cluster]
  depends_on = [ local.eks_depends, local.iam_role_depends ]
}

/*resource "kubernetes_namespace" "airflow_ns" {
  metadata {
    name = "airflow"
  }


resource "helm_release" "airflow-helm" {
  name = "airflow"
  repository = "https://airflow.apache.org"
  chart = "airflow"
  version = "8.8.0"
  namespace = "airflow"
  values = [
    "${file("./values2.yaml")}"
  ]
  set {
    name = "data.metadataConnection.host"
    value = aws_db_instance.postgresql_db.address
  }
  set {
    name = "data.metadataConnection.host"
    value = aws_db_instance.postgresql_db.address
  }
  set {
    name = "data."
    value = ""
  }
}

resource "kubernetes_namespace" "notebook_ns" {
  metadata {
    name = var.namepsace
  }
  #depends_on = [ aws_eks_addon.ebs_csi_addon, null_resource.update_kubeconfig ]
  depends_on = [ null_resource.update_kubeconfig ]
}

/*resource "helm_release" "notebook" {
  name = "notebook"
  chart = "C:/Users/Shree/Downloads/DG-Projects/dataflow-studio/helm-chart"
  namespace = var.namepsace
  values = [
    file("C:/Users/Shree/Downloads/DG-Projects/dataflow-studio/helm-chart/values.yaml")
  ]
  depends_on = [ kubernetes_namespace.notebook_ns, local.eks_depends, local.vpc_depends ]
}

resource "helm_release" "ingress_controller" {
  name = "ingress-controller"
  repository = "oci://ghcr.io/nginxinc/charts"
  chart = "nginx-ingress"
  version = "1.1.3"

  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }

  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-eip-allocations"
    value = "eipalloc-06571868a6b33e8e4\\,eipalloc-0bd5ed40d4e58c585"
  }

  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-security-groups"
    value = aws_security_group.nlb_sg.id
  }

  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-manage-backend-security-group-rules"
    value = "'true'"
  }

  set {
    name = "controller.enableSnippets"
    value = true
  }
  depends_on = [ kubernetes_namespace.notebook_ns, local.eks_depends, local.vpc_depends ]
}


/*resource "helm_release" "cert-manager" {
  name = "certificate"
  chart = "C:/Users/Shree/Downloads/DG-Projects/certificate/certificate"
  depends_on = [ kubernetes_namespace.notebook_ns, local.eks_depends, local.vpc_depends ]
}

resource "helm_release" "dataflow-studio" {
  name = "dataflow-studio"
  repository = "https://Digital-Back-Office.github.io/dataflow-helm-repo"
  chart = "dataflow"
  depends_on = [ kubernetes_namespace.notebook_ns, local.eks_depends, local.vpc_depends ]
}
*/