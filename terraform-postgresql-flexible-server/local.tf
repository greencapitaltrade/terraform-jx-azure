locals {
  resource_group_name = var.resource_group_name != "" ? var.resource_group_name : "rg-psql-${join("", regexall("[A-Za-z0-9\\-_().]", var.cluster_name))}"
}
