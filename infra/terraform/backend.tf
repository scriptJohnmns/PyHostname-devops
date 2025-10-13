terraform {
  backend "s3" {
    bucket  = "terraform-pyhostname-state"
    key     = "pojetoDevops1/terraform.state"
    region  = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}
