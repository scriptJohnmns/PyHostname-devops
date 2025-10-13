resource "aws_key_pair" "pyhostnamekey" {
  key_name   = "aws-key"
  public_key = file("/home/joaomns/.ssh/aws-key/aws-key.pub")
}