locals {
  _files = yamldecode(file("files.yml"))
  files  = { for file in local._files : file["filename"] => file }
}

module "my_file" {
  source = "./tfmod"
  files  = local.files
}

output "show_files" {
  value = local.files
}
