# 1. Define a Role e diz que a EC2 pode usá-la
resource "aws_iam_role" "ec2_ecr_role" {
  name = "EC2-ECR-ReadOnly-Role-Terraform"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# 2. Anexa a política de "ler ECR" à Role
resource "aws_iam_role_policy_attachment" "ec2_ecr_attachment" {
  role       = aws_iam_role.ec2_ecr_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# 3. Cria o (Instance Profile) que a instância vai de fato usar
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2-ECR-Profile-Terraform"
  role = aws_iam_role.ec2_ecr_role.name
}