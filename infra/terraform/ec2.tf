resource "aws_instance" "ec2_pyhost" {
  ami                    = "ami-052064a798f08f0d3"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.pyhostnamekey.key_name
  vpc_security_group_ids = [aws_security_group.pyhostname_sg.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name        = "pyhostname-app"
    Provisioned = "Terraform"
  }
}

resource "aws_security_group" "pyhostname_sg" {
  name   = "pyhostname-sg"
  vpc_id = "vpc-04443bc4da7550d99"

  tags = {
    Name        = "pyhostname-sg"
    Provisioned = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.pyhostname_sg.id
  cidr_ipv4         = "177.152.100.123/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.pyhostname_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.pyhostname_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}