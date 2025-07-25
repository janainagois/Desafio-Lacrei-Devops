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

  user_data     = <<-EOF
                  #!/bin/bash
                  set -e
                  exec > >(tee /var/log/user-data.log) 2>&1
                  sudo yum update -y
                  sudo amazon-linux-extras install docker -y
                  sudo systemctl enable docker
                  sudo systemctl start docker
                  sudo usermod -a -G docker ec2-user
                  for i in {1..3}; do
                    sudo docker pull ${var.docker_image}:${var.environment} && break || sleep 15
                  done
                  sudo docker rm -f meu-app || true
                  sudo docker run -d --name meu-app --restart unless-stopped -p 3000:3000 -e NODE_ENV=${var.environment} ${var.docker_image}:${var.environment}
                  sleep 10
                  sudo docker ps | grep meu-app || { echo "Container falhou!"; sudo docker logs meu-app; exit 1; }
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
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_eip" "app_eip" {
  instance = aws_instance.app.id
}