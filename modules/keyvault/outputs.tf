output "key_vault_name" {
  description = "The name of the Azure Key Vault"
  value       = azurerm_key_vault.key_vault_main.name
}

output "key_vault_id" {
  description = "The ID of the Azure Key Vault"
  value       = azurerm_key_vault.key_vault_main.id
}

output "key_vault_uri" {
  description = "The URI of the Azure Key Vault for accessing secrets"
  value       = azurerm_key_vault.key_vault_main.vault_uri
}

output "key_vault_resource_group" {
  description = "The resource group where the Key Vault is deployed"
  value       = azurerm_key_vault.key_vault_main.resource_group_name
}
