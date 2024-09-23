variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "name_prefix" {
  type = string
  description = "Prefix to add to all Resources"
}

variable "ssh_public_key_file" {
  type = string
  description = "SSH Public Key file path"
}
