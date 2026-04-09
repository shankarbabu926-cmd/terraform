output "storage_account_name" {
  description = "Storage account name"
  value       = azurerm_storage_account.sa.name
}

output "storage_container_name" {
  description = "Storage container name"
  value       = azurerm_storage_container.container.name
}

output "storage_account_primary_blob_endpoint" {
  description = "Primary blob endpoint for the storage account"
  value       = azurerm_storage_account.sa.primary_blob_endpoint
}
