# Using YAML for data

`yamldecode` is a function that returns a dynamic data type that depends on
the structure of the yaml file.

In the previous tutorial you practiced importing yaml in various formats and
seeing how they were created in Terraform.

In this tutorial you will learn how to modify the data structure for your
needs.

We'll start with the same code at the end of the loop_in_module tutorial.

!!! The starting code is in the loop_in_module directory.

!!! The student is expected to competent in using computers, just not familiar
!!! with terraform. No need to explain basic concepts like what creating
!!! a file is.

!!! The tfmod has been discussed in a previous tutorial, no need to go into
!!! details. If necessary a pointer to that tutorial can be included.

!!! The basic details of the main.tf, and other tf files, have already been
!!! discussed. Don't explain those.

!!! Output for terraform init, fmt, and validate have already been covered.
!!! Output from these commands will only be shown when they expected to fail.

## Using a yaml map of maps

!!! Use map_of_maps directory

!!! Note differences between loop_in_module (end of last tutorial) and
!!! map_of_maps

* Create and change to directory `create_from_yaml`
* Create `main.tf` with the following content:

```hcl
locals {
  files = yamldecode(file("files.yml"))
}

module "my_file" {
  source = "./tfmod"
  files  = local.files
}
```

* Create and change to module directory `tfmod`
* Create `versions.tf` with the following content:

```hcl
terraform {
  required_providers {
    local = { source = "hashicorp/local" }
  }
}
```

* Create `variables.tf` with the following content:

```hcl
variable "files" {
  type = map(object({
    filename    = string,
    content     = string,
    permissions = string
  }))
}
```

* Create `main.tf` with the following content:

```hcl
locals {
  files = { for file in var.files : file["filename"] => file }
}

resource "local_file" "file" {
  for_each = local.files

  filename        = each.key
  content         = each.value["content"]
  file_permission = each.value["permissions"]
}
```

* Create `outputs.tf` (this file is currently empty)

* Go back one directory to `create_from_yaml`
* Create `files.yml` with the following content:

```yaml
modloop1:
  content: "This is modloop1"
  permissions: "0777"
modloop2:
  content: "This is modloop2"
  permissions: "0777"
```

* terraform init && terraform fmt && terraform validate
* terraform plan

## Using a yaml list of maps

If that were the only format your yaml data would come in, we'd be done.
However, yaml data can also come in the following format.

The `tfmod` module is using `for_each` which expects either a set of objects
or a set of maps. (Link confluence page here)

## A set of objects

A set of objects is an array of simple strings.

```
[ 'string1', 'string2', ... ]
```

## A set of maps

A set of maps is a dict, where the value can be a simple type or an object.

```
{
  key1 => object,
  key2 => object
}
```

## Read a list of maps from YAML

!!! Use list_of_maps directory and show_first directories.

In some cases, your YAML data might be structured as a list of maps. This is
a common format for representing a collection of similar objects. Each map in
the list represents an object, and the keys and values in the map represent
the properties of the object.

* Modify `files.yml` to have a list of maps.

```yaml
- filename: "modloop1"
  content: "This is modloop1"
  permissions: "0777"
- filename: "modloop2"
  content: "This is modloop2"
  permissions: "0777"
```

In this example, each map in the list represents a file. The `filename` key
specifies the name of the file, the `content` key specifies the content of the
file, and the `permissions` key specifies the permissions of the file.

To read a list of maps from a YAML file in Terraform, you can use the
`yamldecode` function, similar to how you would read a map of maps. However,
because the `yamldecode` function returns a dynamic data type, you need to
ensure that your Terraform code can handle a list of maps.

* terraform init && terraform fmt && terraform validate
  + show the error that will be generated
* Comment out the module call in main.tf and run `terraform init`,
  `terraform fmt`, and `terraform validate` again to check for errors.
  + show commented code
* Run `terraform plan` to see the planned changes. The output should show the
  list of maps that was read from the `files.yml` file.

## Convert a list of maps to a set of maps

!!! Use use_for directory

We need to convert that input to a set of maps. We can use the `for` function
to create a set of maps. The `for` function in Terraform allows you to iterate
over a collection and transform it into a new collection. In this case, we are
transforming a list of maps into a set of maps. This is done by iterating over
each map in the list and creating a new map with the desired structure.

Here is an example of how you can use the `for` function to convert a list of
maps to a set of maps:

```hcl
locals {
  _files = yamldecode(file("files.yml"))
  files  = { for file in local._files : file["filename"] => file }
}
```

In this example, `local._files` is a list of maps. The `for` function iterates
over each map in the list (represented by `file`), and for each iteration, it
creates a new map where the key is `file["filename"]` and the value is the
entire `file` map. The result is a set of maps stored in `local.files`.

* Modify `main.tf` to use a for loop and create a set of maps
* terraform init && terraform fmt && terraform validate
* terraform plan




