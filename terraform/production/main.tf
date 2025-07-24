module "app" {
  source    = "../modules/ec2_app"
  key_name  = var.key_name
  my_ip     = var.my_ip
}