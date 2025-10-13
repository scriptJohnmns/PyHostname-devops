resource "aws_ecr_repository" "ecr_pyhost" {
  name                 = "pyhostname-ecr"
  image_tag_mutability = "MUTABLE"

  force_delete         = true
}