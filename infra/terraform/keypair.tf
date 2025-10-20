resource "aws_key_pair" "pyhostname_key" {
  # O nome que a chave terá lá no console da AWS
  key_name = "pyhostname-key-permanente"

  public_key = file("${path.module}/../ssh/pyhostnamekey-tf.pub")
}


/* CODIDO PRA GERAR CHAVE AUTOMATICO
# 1. Gera um par de chaves (pública e privada) em memória
resource "tls_private_key" "pyhostname_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2. Pega a chave PÚBLICA que foi gerada e a envia para a AWS
resource "aws_key_pair" "pyhostname_key" {
  key_name   = "pyhostnamekey-tf"
  public_key = tls_private_key.pyhostname_key.public_key_openssh
}

# 3. Pega a chave PRIVADA que foi gerada e a salva em um arquivo para podermos usar no SSH/Ansible
resource "local_file" "private_key_pem" {
  content         = tls_private_key.pyhostname_key.private_key_pem
  filename        = "pyhostnamekey.pem"
  file_permission = "0400" # Permissão restrita, só o dono pode ler/escrever
}
*/
