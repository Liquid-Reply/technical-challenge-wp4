variable "grafana_version" {
    type = string
    description = "Grafana Version to use"
}

variable "resource_group_name" {
    type = string
    description = "Name of the Resource Group"
}

variable "vm_ids" {
    type = map(string)
    description = "Map of created Virtual Machine IDs"
}

variable "identity_id" {
    type = string
    description = "ID of the VM Identity"
}

variable "name_prefix" {
    type = string
    description = "Prefix to add to all Resources"
}
