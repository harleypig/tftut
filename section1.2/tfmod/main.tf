#locals {
#  files = { for file in var.files : file["filename"] => file }
#}

resource "local_file" "file" {
  for_each = var.files

  filename        = each.key
  content         = each.value["content"]
  file_permission = each.value["permissions"]
}
