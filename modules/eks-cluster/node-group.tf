# resource "aws_eks_node_group" "default" {
#   cluster_name    = aws_eks_cluster.default.name
#   node_group_name = "tf-ng-${var.project_name}-0"
#   node_role_arn   = aws_iam_role.node_group.arn
#   subnet_ids      = var.subnet_ids
#   ami_type        = "AL2_x86_64"

#   scaling_config {
#     desired_size = 1
#     max_size     = 1
#     min_size     = 1
#   }

#   # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#   # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#   depends_on = [
#     aws_iam_role_policy_attachment.node_group-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.node_group-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.node_group-AmazonEC2ContainerRegistryReadOnly,
#   ]
# }
