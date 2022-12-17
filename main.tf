terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "terraform-luis"

    workspaces {
      name = "challenge-terraform"
    }
  }
}

## Error que obtengo cuando corre este bloque es el mismo que este
## https://github.com/GoogleCloudPlatform/terraformer/issues/1428
## Error fue resuelto mediante la utilizacion de las variables de ambiente en TF Cloud como
## AWS_ACCESS_KEY en vez de TF_AWS_ACCESS_KEY

provider "aws" {
  region = "us-east-1"
}
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_pet" "sg" {}

resource "aws_key_pair" "generated_key" {
  key_name   = "aws_key_for_ansible"
  public_key = tls_private_key.example.public_key_openssh
}

resource "aws_instance" "web" {
  ami                    = "ami-026b57f3c383c2eec"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  key_name = aws_key_pair.generated_key.key_name

  provisioner "remote-exec"{
    inline = ["echo 'wait until SSH is ready'"]

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = tls_private_key.example.private_key_pem
      host = aws_instance.web.public_ip
    }
  }

}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"
  
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // connectivity to ubuntu mirrors is required to run `apt-get update` and `apt-get install apache2`
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

output "test-value" {
  value = "Instancia de AWS completada de manera correcta"
}

output "private_key" {
  value     = nonsensitive(tls_private_key.example.private_key_pem)
}

output "web-address" {
  value = "${aws_instance.web.public_dns}:80"
}
