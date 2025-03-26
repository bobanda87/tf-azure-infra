output "resource_group_names" {
  description = "The names of the created resource groups"
  value       = [for rg in azurerm_resource_group.rg : rg.name]
}