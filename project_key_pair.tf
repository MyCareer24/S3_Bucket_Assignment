#CREATIING BOTH PUBLIC AND PRIVATE KEY PAIR AND STORING IT ON YOUR LOCAL MACHINE

resource "tls_private_key" "Project_RSA_4096"{
  algorithm = "RSA"
  rsa_bits = 4096
}

#CREATE PUBLIC KEY TO BE STORED IN THE SERVER
resource "aws_key_pair" "project_kp"{
  key_name = var.key_name
  public_key = tls_private_key.Project_RSA_4096.public_key_openssh
}

#CREATE PRIVATE KEY TO STORE IN YOUR MACHINE
resource "local_file" "private_key"{
  content = tls_private_key.Project_RSA_4096.private_key_pem
  filename = var.key_name
}