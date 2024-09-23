output "vm_ips" {
  value = module.compute.vm_ips
}

output "user_identity_client_id" {
    value = data.azurerm_user_assigned_identity.identity.client_id
}
