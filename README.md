# Using YAML for data

`yamldecode` is a function that returns a dynamic data type that depends on
the structure of the yaml file.

In the previous tutorial you practiced importing yaml in various formats and
seeing how they were created in Terraform.

In this tutorial you will learn how to modify the data structure for your
needs.

We'll start with the same code at the end of the loop_in_module tutorial.

!!! The starting code is in the loop_in_module directory.

!!! The student is expected to competent in using computers, just not familiar with terraform. No need to explain basic concepts like what creating a file is.

!!! The tfmod has been discussed in a previous tutorial, no need to go into details. If necessary a pointer to that tutorial can be included.

!!! The basic details of the main.tf, and other tf files, have already been discussed. Don't explain those.

!!! Output for terraform init, fmt, and validate have already been covered.

!!! Output from these commands will only be shown when they expected to fail.

## Processing YAML Data Structured as a Map of Maps

!!! Use section1.1 directory

!!! Note differences between loop_in_module (end of last tutorial) and map_of_maps

* Create and change to directory `create_from_yaml`
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
  type        = string
  description = "name of yaml file"
  default     = "files.yml"
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
* Create `main.tf` with the following content:

```hcl
locals {
  files = yamldecode(file(var.files))
}

module "my_file" {
  source = "./tfmod"
  files  = local.files
}
```

Here we add a locals block.

This block is used to define a local variable `files` which is assigned the
value returned by the `yamldecode(file("files.yml"))` function. This function
reads the `files.yml` file and decodes the YAML content into a Terraform value.

* Create `files.yml` with the following content:

```yaml
modloop1:
  content: "This is modloop1"
  permissions: "0644"
modloop2:
  content: "This is modloop2"
  permissions: "0644"
```

* terraform init && terraform fmt && terraform validate
  + show error that results

!!! use section1.2 directory

* Comment the call to the tfmod module in the main.tf

```hcl
locals {
  files = yamldecode(file(var.files))
}

#module "my_file" {
#  source = "./tfmod"
#  files  = local.files
#}
```

* terraform init && terraform fmt && terraform validate
* terraform plan
  + show expected output

## tfmod requires a set of maps

The `tfmod` module is using `for_each` which expects either a set of objects
or a set of maps. (Link confluence page here)

The `tfmod` module is expecting a data structure that includes an attribute
called `filename` which it will use as a key for the objects that were passed
in.

### A set of objects

A set of objects is an array of simple strings.

```
[ 'string1', 'string2', ... ]
```

### A set of maps

A set of maps is a dict, where the value can be a simple type or an object.

```
{
  key1 => object,
  key2 => object
}
```

## Read a list of maps from YAML

!!! use section2.1 directory

* Uncomment the call to the module in your main.tf

```yaml
locals {
  files = yamldecode(file(var.files))
}

module "my_file" {
  source = "./tfmod"
  files  = local.files
}
```

* Modify `files.yml` to have a list of maps.

```yaml
- filename: "modloop1"
  content: "This is modloop1"
  permissions: "0777"
- filename: "modloop2"
  content: "This is modloop2"
  permissions: "0777"
```

* terraform init && terraform fmt && terraform validate
* terraform plan
  + show expected error

* Modify `tfmod/variables.tf` to use a list instead of a map

```yaml
variable "files" {
  type = list(object({
    filename    = string,
    content     = string,
    permissions = string
  }))
}
```

* terraform init && terraform fmt && terraform validate
* terraform plan
  + show expected output

## Convert a list of maps to a set of maps

!!! Use section3.1 directory

Sometimes we can't change the module we are using.

* Modify `tfmod/variables.tf` to its previous state

```yaml
variable "files" {
  type = map(object({
    filename    = string,
    content     = string,
    permissions = string
  }))
}
```

We need to convert that input to a set of maps. We can use the `for` function
to create a set of maps. The `for` function in Terraform allows you to iterate
over a collection and transform it into a new collection. In this case, we are
transforming a list of maps into a set of maps. This is done by iterating over
each map in the list and creating a new map with the desired structure.

* Modify `main.tf` to match the following code

```hcl
locals {
  _files = yamldecode(file(var.files))
  files  = { for file in local._files : file["filename"] => file }
}

module "my_file" {
  source = "./tfmod"
  files  = local.files
}
```

In the `locals` block, `_files` is a local variable that holds the result of decoding the YAML file specified in `var.files`. This decoded data is a list of maps, where each map represents a file with its attributes. The `files` local variable then transforms this list of maps into a map of maps, where the key is the filename and the value is the corresponding map of attributes. This transformation is necessary because the `tfmod` module expects a map of maps as input.
```

In this example, `local._files` is a list of maps. The `for` function iterates
over each map in the list (represented by `file`), and for each iteration, it
creates a new map where the key is `file["filename"]` and the value is the
entire `file` map. The result is a set of maps stored in `local.files`.

* terraform init && terraform fmt && terraform validate
* terraform plan
  + show expected output

## Convert data from yaml to something the tfmod can use

!!! use section3.2 directory

Sometimes you can neither change the data format nor the module code; you need
to convert your data from one format to another. We'll be using the `merge`
and `flatten` functions to do this.

* Modify `files.yml` to its original format.

```yaml
modloop1.txt:
  content: first file
  permissions: 0644
modloop2.txt:
  content: second file
  permissions: 0755
```

* terraform init && terraform fmt && terraform validate
* terraform plan
  + show expected error
