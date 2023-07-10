# Using YAML for data

`yamldecode` is a function that returns a dynamic data type that depends on
the structure of the yaml file.

In the previous tutorial you practiced importing yaml in various formats and
seeing how they were created in Terraform.

In this tutorial you will learn how to modify the data structure for your
needs.

## Using a yaml map of maps

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
* Create yaml file `files-maps.yml`

## Using a yaml list of maps

* Create 
