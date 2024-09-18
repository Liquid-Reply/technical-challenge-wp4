variable "grafana_version" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "vm_ids" {
    type = map(string)
}

variable "identity_id" {
    type = string
}

variable "name_prefix" {
    type = string
}
