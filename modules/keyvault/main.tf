resource "azurerm_key_vault" "key_vault_main" {
  name                       = "kv-${var.environment}-${var.region}-${var.identifier}"
  location                   = var.region
  resource_group_name        = var.resource_group_name
  sku_name                   = "standard"
  tenant_id                  = var.tenant_id
  soft_delete_retention_days = 7
  tags                       = var.tags
}
