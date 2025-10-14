resource "local_file" "ansible_inventory" {

  content = templatefile("${path.module}/../ansible/inventory.tpl", {
    public_ip = aws_instance.ec2_pyhost.public_ip
  })

  filename = "${path.module}/../ansible/inventory"
}