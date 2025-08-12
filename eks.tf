resource "aws_eks_cluster" "eks-cluster" {
  name = var.cluster_name

  role_arn = aws_iam_role.eks-cluster.arn

  vpc_config {
    subnet_ids = var.aws_public_subnet
    endpoint_public_access  = true
    public_access_cidrs = var.public_access_cidrs
    security_group_ids = [aws_security_group.node_group_one.id]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    
  ]
}

resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-example"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}
