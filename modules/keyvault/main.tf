resource "azurerm_key_vault" "key_vault_main" {
  name                        = "kv-${var.environment}-${var.region}-${var.identifier}"
  location                    = var.region
  resource_group_name         = var.resource_group_name
  sku_name                    = "standard"
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  tags                        = var.tags
  purge_protection_enabled    = true
  enabled_for_disk_encryption = true

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = var.key_vault_ip_rules
    virtual_network_subnet_ids = var.key_vault_vnet_subnet_ids
  }
}
