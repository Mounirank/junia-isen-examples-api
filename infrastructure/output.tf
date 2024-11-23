# outputs.tf

# Resource Group Outputs
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "The location of the resource group"
  value       = azurerm_resource_group.main.location
}

# Network Outputs
output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = module.network.vnet_id
}
