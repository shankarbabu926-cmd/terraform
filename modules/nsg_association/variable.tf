variable "subnet_ids" {
  description = "Map of subnet names to subnet IDs"
  type        = map(string)
}

variable "network_security_group_id" {
  description = "ID of the network security group to associate"
  type        = string
}
