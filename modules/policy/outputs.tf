output "policy_definition_id" {
  description = "The ID of the created Azure Policy Definition for restricted regions"
  value       = azurerm_policy_definition.restrict_regions.id
}

output "policy_assignment_id" {
  description = "The ID of the Azure Policy Assignment for restricted regions"
  value       = azurerm_subscription_policy_assignment.assign_restrict_regions.id
}

output "policy_display_name" {
  description = "The display name of the Azure Policy for restricted regions"
  value       = azurerm_subscription_policy_assignment.assign_restrict_regions.display_name
}
