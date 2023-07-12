locals {
  files = yamldecode(file(var.files))
}

#module "my_file" {
#  source = "./tfmod"
#  files  = local.files
#}
