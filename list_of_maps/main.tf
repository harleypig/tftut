locals {
  files = yamldecode(file("files.yml"))
}

module "my_file" {
  source = "./tfmod"
  files  = local.files
}

output "show_files" {
  value = local.files
}
