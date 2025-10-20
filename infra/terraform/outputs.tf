output "public_ip" {
  description = "Endereço de IP público da instância EC2"
  value       = aws_instance.ec2_pyhost.public_ip
}

output "ecr_repository_url" {
  description = "URL do repositório ECR"
  # ecr_pyhost
  value = aws_ecr_repository.ecr_pyhost.repository_url
}

