variable "tenant_id" {
  type = string
  description = "Tenant ID"
}

variable "subscription_id" {
  type = string
  description = "Subscription ID"
}

variable "storage_account_name" {
  type = string
  description = "Name of the State Storage Account"
}

variable "resource_group_name" {
  type = string
  description = "Name of the Resource Group"
}

variable "resource_group_location" {
  type = string
  description = "Location of the Resource Group"
}

variable "name_prefix" {
  type = string
  description = "Prefix to add to all Resources"
}

variable "ssh_public_key_file" {
  type        = string
  description = "SSH Public Key file path"
}
