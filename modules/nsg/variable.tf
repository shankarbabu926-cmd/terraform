variable "name" {
  description = "Name of the network security group"
  type        = string
}

variable "location" {
  description = "Azure region for the NSG"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the NSG"
  type        = string
}

variable "tags" {
  description = "Tags for the NSG"
  type        = map(string)
  default     = {}
}
