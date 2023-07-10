terraform {
  required_providers {
    local = { source = "hashicorp/local" }
  }
}

variable "files" {
  type = map(object({
    filename    = string,
    content     = string,
    permissions = string
  }))
}

#locals {
#  files = { for file in var.files : file["filename"] => file }
#}

resource "local_file" "file" {
  for_each = var.files

  filename        = each.value["filename"]
  content         = each.value["content"]
  file_permission = each.value["permissions"]
}
