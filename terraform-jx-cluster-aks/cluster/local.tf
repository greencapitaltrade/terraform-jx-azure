resource "random_pet" "name" {
}

locals {
  ingress_ip_name                 = var.ingress_ip_name != "" ? join("", regexall("[A-Za-z0-9\\-]", var.ingress_ip_name)) : join("", regexall("[A-Za-z0-9\\-]", random_pet.name.id))
}
