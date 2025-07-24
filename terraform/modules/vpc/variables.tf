variable "environment" {
  description = "Nome do ambiente (ex.: staging, production)"
  type        = string
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC (ex.: 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Lista de CIDRs das subnets públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]  
}

variable "aws_region" {
  description = "Região da AWS (ex.: us-east-1)"
  type        = string
}