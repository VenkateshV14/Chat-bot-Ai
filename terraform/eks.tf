resource "aws_eks_cluster" "chatbot_cluster" {
  name     = "chatbot-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.30"

  vpc_config {
    subnet_ids = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id
    ]
    endpoint_public_access  = true
    endpoint_private_access = false
  }

  tags = {
    Name = "chatbot-cluster"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSVPCResourceController
  ]
}

resource "aws_eks_node_group" "chatbot_nodegroup" {
  cluster_name    = aws_eks_cluster.chatbot_cluster.name
  node_group_name = "chatbot-nodegroup"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  instance_types = ["t2.medium"]
  ami_type       = "AL2_x86_64"

  tags = {
    Name = "chatbot-nodegroup"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks_node_AmazonEKS_CNI_Policy
  ]
}
