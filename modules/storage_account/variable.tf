variable "name" {
  description = "Storage account name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the storage account"
  type        = string
}

variable "location" {
  description = "Azure region for the storage account"
  type        = string
}

variable "container_name" {
  description = "Blob container name for backend or data storage"
  type        = string
}

variable "tags" {
  description = "Tags for the storage account"
  type        = map(string)
  default     = {}
}
