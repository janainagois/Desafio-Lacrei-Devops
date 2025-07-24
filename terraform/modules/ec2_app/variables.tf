variable "key_name" {
  type = string
}

variable "my_ip" {
  type = string
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