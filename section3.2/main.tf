locals {
  _files = [
    for key, file in yamldecode(file(var.files)) :
    merge(file, {
      filename    = "${key}"
      content     = file.content
      permissions = file.permissions
  })]

  files = { for file in local._files : file["filename"] => file }
}

module "my_file" {
  source = "./tfmod"
  files  = local.files
}
