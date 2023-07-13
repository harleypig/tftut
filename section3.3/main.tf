locals {
  _files = flatten([
    for file in fileset(var.yaml_dir, "**/*.yml") : [
      for key, data in yamldecode(file("${var.yaml_dir}/${file}")) :
      merge(data, {
        filename    = "${key}"
        content     = data.content
        permissions = data.permissions
  })]])

  files = { for file in local._files : file["filename"] => file }
}

module "my_file" {
  source = "./tfmod"
  files  = local.files
}
