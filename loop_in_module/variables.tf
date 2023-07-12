variable "files" {
  type = list(object({
    filename = string,
    content = string,
    permissions = string,
  }))
  description = "a list of files"
  default = [
    {
      filename = "modloop1.txt"
      content = "first file"
      permissions = "0644"
    },
    {
      filename = "modloop2.txt"
      content = "second file"
      permissions = "0755"
    }
  ]
}
