variable "key_name" {
  type = string
  default = "nome-padrao"
  description = "Nome da chave SSH para acesso à instância EC2"
}

variable "my_ip" {
  description = "IP para acesso SSH"
  type        = string
  default     = "0.0.0.0/32"
}

variable "vpc_id" {
  description = "ID da VPC onde a instância será criada"
  type        = string
}

variable "subnet_id" {
  description = "ID da subnet pública"
  type        = string
}

variable "environment" {
  description = "Ambiente (staging/production)"
  type        = string
}

variable "app_port" {
  description = "The port on which the application will run"
  type        = number
  default     = 3000
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"
}

variable "docker_image" {
  description = "Nome da imagem Docker no registry"
  type        = string
  default     = "janainagois/app-node"
}