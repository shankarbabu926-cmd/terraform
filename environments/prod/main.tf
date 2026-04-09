module "resource_group" {
  source = "../../modules/resourcegroup"

  name     = var.resource_group_name
  location = var.location
}

module "storage_account" {
  source = "../../modules/storage_account"

  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location
  container_name      = var.storage_container_name
  tags = {
    environment = "prod"
  }
}

module "vnet" {
  source = "../../modules/vnet"

  vnet_name           = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  subnets = {
    (var.subnet_name) = {
      address_prefixes = [var.subnet_address_prefix]
    }
  }

  depends_on = [module.resource_group]
}

module "nsg" {
  source = "../../modules/nsg"

  name                = "${var.vnet_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

module "nsg_association" {
  source = "../../modules/nsg_association"

  subnet_ids                = module.vnet.subnet_ids
  network_security_group_id = module.nsg.nsg_id

  depends_on = [module.vnet, module.nsg]
}

