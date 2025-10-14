resource "aws_ecr_repository" "ecr_pyhost" {
  name                 = "pyhostname-ecr"
  image_tag_mutability = "MUTABLE"

  force_delete = true
}

resource "aws_ssm_parameter" "ecr_url" {
  name  = "/pyhostname/dev/ecr_repository_url"
  type  = "String"
  value = aws_ecr_repository.ecr_pyhost.repository_url
}