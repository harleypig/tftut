# Using YAML for data

`yamldecode` is a function that returns a dynamic data type that depends on
the structure of the yaml file.

In the previous tutorial you practiced importing yaml in various formats and
seeing how they were created in Terraform.

In this tutorial you will learn how to modify the data structure for your
needs.

## Simple example

* Create files using `files-simple.yml`

Straight import, no modifications needed in either the data or the code.

```hcl
locals { data = yamldecode(file("files-simple.yml")) }

module "my_file" {
  for_each = local.data

  source = "./tfmod"
  files  = each.value
}
```

