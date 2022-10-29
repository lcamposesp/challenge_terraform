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

# Deploy an EC2 Instance.
resource "aws_instance" "example" {
  # Run an Ubuntu 18.04 AMI on the EC2 instance.
  ami                    = "ami-0d5d9d301c853a04a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  # When the instance boots, start a web server on port 8080 that responds with "Hello, World!".
  user_data = <<EOF
#!/bin/bash
echo "Hello, World!" > index.html
nohup busybox httpd -f -p 8080 &
EOF
}

# Allow the instance to receive requests on port 8080.
resource "aws_security_group" "instance" {
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Output the instance's public IP address.
output "public_ip" {
  value = aws_instance.example.public_ip
}