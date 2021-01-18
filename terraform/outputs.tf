data "aws_region" "current" {}

output "eks_cluster_id" {
  value = module.eks_cluster.eks_cluster_id
}

output "eks_cluster_region" {
  value = data.aws_region.current.name
}
