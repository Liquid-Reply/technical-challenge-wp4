data "azurerm_virtual_machine" "machines" {
  for_each            = module.compute.vm_names
  name                = each.key
  resource_group_name = var.resource_group_name
  depends_on          = [module.compute]
}

data "azurerm_user_assigned_identity" "identity" {
  name                = "${var.name_prefix}-identity"
  resource_group_name = var.resource_group_name
  depends_on          = [module.compute]
}

module "compute" {
  source = "./modules/compute"

  resource_group_name = var.resource_group_name
  name_prefix         = var.name_prefix
  ssh_public_key_file = var.ssh_public_key_file
}

module "monitoring" {
  source = "./modules/monitoring"

  resource_group_name = var.resource_group_name
  grafana_version     = "10"
  vm_ids              = module.compute.vm_ids
  identity_id         = data.azurerm_user_assigned_identity.identity.principal_id

  name_prefix = var.name_prefix
}
