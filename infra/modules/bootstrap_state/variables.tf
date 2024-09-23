variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to create"
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group to create"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the Storageaccount to hold the Terraform state"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags which should be assigned to the created resources"
}

variable "subscription_id" {
  type        = string
  description = "The subscription ID to use"
}

variable "tenant_id" {
  type = string
  description = "Tenant ID"
}
