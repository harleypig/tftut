# Using YAML for data

`yamldecode` is a function that returns a dynamic data type that depends on
the structure of the yaml file.

In the previous tutorial you practiced importing yaml in various formats and
seeing how they were created in Terraform.

In this tutorial you will learn how to modify the data structure for your
needs.

## Using a yaml map of maps

!!! Use map_of_maps directory

* Create and change to directory `create_from_yaml`
* Create main.tf
* Add code
  * This file is the main Terraform configuration file. It uses the
    `yamldecode` function to read the `files-maps.yml` file and store its
    content in a local variable. It then calls the `my_file` module, passing
    the local variable as an argument.

* Create and change to module directory `tfmod`
* Create module main.tf
* Add code
  * This file is the Terraform module configuration file. It defines
    a variable `files` that expects a map of objects. It then creates
    a `local_file` resource for each item in the `files` map, using the map's
    keys and values to set the resource's properties.

* Go back one directory to `create_from_yaml`
* Create yaml file `files.yml`
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

* Modify `files.yml` to have a list of maps.
* terraform init && terraform fmt && terraform validate
* add error output
* comment module call and run init, fmt, validate again
* terraform plan, show output

## Convert a list of maps

We need to convert that to a dict. We can use the `merge` function to create
a set of maps.

* Modify `main.tf` to use a for loop and create a set of maps




