locals {
  files = yamldecode(file("files.yml"))
}

module "my_file" {
  source = "./tfmod"
  files  = local.files
}
