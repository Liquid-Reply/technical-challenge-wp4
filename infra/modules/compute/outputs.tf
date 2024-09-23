output "vm_names" {
  description = "The names of the virtual machines"
  value       = { for vm in azurerm_linux_virtual_machine.wp4 : vm.name => vm.name }
}


output "vm_ids" {
  description = "The IDs of the virtual machines"
  value       = { for vm in azurerm_linux_virtual_machine.wp4 : vm.name => vm.id }
}

output "vm_identity_name" {
    value = azurerm_user_assigned_identity.vm.name
}

output "vm_ips" {
  value = { for vm in azurerm_linux_virtual_machine.wp4 : vm.name => vm.public_ip_address }
}
