locals {
  _files = yamldecode(file(var.files))
  files  = { for file in local._files : file["filename"] => file }
}

module "my_file" {
  source = "./tfmod"
  files  = local.files
}
