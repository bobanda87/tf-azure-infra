# outputs.tf
output "vnet_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "frontend_subnet_id" {
  description = "The ID of the frontend subnet"
  value       = azurerm_subnet.subnet_frontend.id
}

output "backend_subnet_id" {
  description = "The ID of the backend subnet"
  value       = azurerm_subnet.subnet_backend.id
}

output "frontend_nsg_id" {
  description = "The ID of the frontend NSG"
  value       = azurerm_network_security_group.nsg_frontend.id
}

output "backend_nsg_id" {
  description = "The ID of the backend NSG"
  value       = azurerm_network_security_group.nsg_backend.id
}

# output "stg_private_endpoint_id" {
#   description = "The ID of the private endpoint"
#   value       = azurerm_private_endpoint.stg_private_endpoint.id
# }
