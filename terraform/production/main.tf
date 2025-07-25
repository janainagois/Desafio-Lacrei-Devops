module "vpc" {
  source        = "../../modules/vpc"
  environment   = "staging"
  vpc_cidr      = "10.1.0.0/16"  # CIDR diferente do production
  public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
  aws_region    = "us-east-1"
}

module "app" {
  source      = "../../modules/ec2_app"
  vpc_id      = module.vpc.vpc_id           # ID da VPC criada pelo módulo vpc
  subnet_id   = module.vpc.public_subnet_ids[0] # Usa o primeiro subnet público
  app_port    = 3000                        # Porta da sua app Node.js
  environment = "production"                   # Define o ambiente
  key_name    = var.key_name                # Sua chave SSH
  my_ip       = var.my_ip                   # Seu IP para acesso SSH
}




 