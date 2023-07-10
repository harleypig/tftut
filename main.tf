locals { files = yamldecode(file("files.yml")) }

module "my_file" {
  for_each = local.files

  source = "./tfmod"
  files  = each.value
}

output "show_files" {
  value = local.files
}
