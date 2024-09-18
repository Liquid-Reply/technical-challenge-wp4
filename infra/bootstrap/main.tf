module "bootstrap" {
  source                        = "../modules/bootstrap_state"
  tenant_id                     = var.tenant_id
  subscription_id               = var.subscription_id
  stage_resource_group          = var.resource_group_name
  stage_resource_group_location = var.resource_group_location
  storage_account_name          = var.storage_account_name
}
