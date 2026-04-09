locals {
  environment = var.environment
  location    = var.location
  region      = replace(lower(var.location), " ", "")

  rg_name                = "rg-${local.environment}-${local.region}"
  vnet_name              = "vnet-${local.environment}-${local.region}"
  subnet_name            = "subnet-${local.environment}-${local.region}"
  nsg_name               = "nsg-${local.environment}-${local.region}"
  storage_account_name   = "sta${local.environment}${local.region}"
  storage_container_name = "container-${local.environment}-${local.region}"

  tags = {
    environment = local.environment
  }

  subnets = {
    (local.subnet_name) = {
      address_prefixes = [var.subnet_address_prefix]
    }
  }
}
