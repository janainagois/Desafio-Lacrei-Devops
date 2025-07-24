resource "aws_instance" "app" {
  ami           = "ami-0cbbe2c6a1bb2ad63" # Amazon Linux 2 (x86_64)(us-east-1)
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = var.subnet_id           
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name        = "AppInstance-${var.environment}"
    Environment = var.environment
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install docker -y
              systemctl start docker
              systemctl enable docker
              
              # Adicione aqui seu comando para rodar o container Node.js
              docker run -d -p ${var.app_port}:${var.app_port} sua-imagem-node
              EOF
}

resource "aws_security_group" "app_sg" {
  name        = "app-sg-${var.environment}"
  description = "Allow SSH and app port"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }
}