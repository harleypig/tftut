variable "files" {
  type = list(object({
    filename    = string,
    content     = string,
    permissions = string
  }))
}
