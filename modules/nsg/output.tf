output "nsg_id" {
  description = "The ID of the created network security group"
  value       = azurerm_network_security_group.this.id
}
