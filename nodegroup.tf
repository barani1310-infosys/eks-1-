resource "aws_eks_node_group" "public" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${local.dynamic_cluster_name}-public-ng"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = aws_subnet.public[*].id

  scaling_config {
    desired_size = var.public_node_desired_size
    max_size     = var.public_node_max_size
    min_size     = var.public_node_min_size
  }

  ami_type       = "AL2_x86_64"
  instance_types = var.node_group_instance_types
  capacity_type  = "ON_DEMAND"
  disk_size      = 20

  labels = {
    "nodegroup-type" = "public"
  }

  tags = merge(var.tags, {
    Name = "${local.dynamic_cluster_name}-public-ng"
  })

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_readonly
  ]
}

# resource "aws_eks_node_group" "private" {
# cluster_name = aws_eks_cluster.main.name
#   node_group_name = "${local.dynamic_cluster_name}-private-ng"
#   node_role_arn   = aws_iam_role.eks_nodes.arn
#   subnet_ids      = aws_subnet.private[*].id

#   scaling_config {
#     desired_size = var.private_node_desired_size
#     max_size     = var.private_node_max_size
#     min_size     = var.private_node_min_size
#   }

#   ami_type       = "AL2_x86_64"
#   instance_types = var.node_group_instance_types
#   capacity_type  = "ON_DEMAND"
#   disk_size      = 20

#   labels = {
#     "nodegroup-type" = "private"
#   }

#   taint {
#     key    = "dedicated"
#     value  = "private"
#     effect = "NO_SCHEDULE"
#   }

#   tags = merge(var.tags, {
#     Name = "${local.dynamic_cluster_name}-private-ng"
#   })

#   depends_on = [
#     aws_iam_role_policy_attachment.eks_worker_node_policy,
#     aws_iam_role_policy_attachment.eks_cni_policy,
#     aws_iam_role_policy_attachment.ec2_container_registry_readonly
#   ]
# }