terraform {
  backend "azurerm" {
    resource_group_name  = "dev-rg-tf"
    storage_account_name = "sa-dev-01"
    container_name       = "dev.tfstate"
    key                  = "terraform.tfstate"
  }
}