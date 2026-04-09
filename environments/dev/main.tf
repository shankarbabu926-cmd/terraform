module "resource_group" {
  source = "../../modules/resourcegroup"

  name     = local.rg_name
  location = local.location
}

module "storage_account" {
  source = "../../modules/storage_account"

  name                = local.storage_account_name
  resource_group_name = local.rg_name
  location            = local.location
  container_name      = local.storage_container_name
  tags                = local.tags
}

module "vnet" {
  source = "../../modules/vnet"

  vnet_name           = local.vnet_name
  location            = local.location
  resource_group_name = local.rg_name
  address_space       = var.vnet_address_space
  subnets             = local.subnets

  depends_on = [module.resource_group]
}

module "nsg" {
  source = "../../modules/nsg"

  name                = local.nsg_name
  location            = local.location
  resource_group_name = local.rg_name
}

module "nsg_association" {
  source = "../../modules/nsg_association"

  subnet_ids                = module.vnet.subnet_ids
  network_security_group_id = module.nsg.nsg_id

  depends_on = [module.vnet, module.nsg]
}
