###
# Resource groups
###

resource "azurerm_resource_group" "rg" {
  for_each = toset([for name in var.resource_group_names : "rg-${var.environment}-${name}"])

  name     = each.value
  location = var.region
}

###
# Modules
###

module "network" {
  source                    = "./modules/network"
  environment               = var.environment
  region                    = var.region
  identifier                = "001"
  resource_group_name       = azurerm_resource_group.rg["rg-${var.environment}-shared"].name
  location                  = var.region
  vnet_address_space        = ["10.0.0.0/16"]
  frontend_address_prefixes = ["10.0.1.0/24"]
  backend_address_prefixes  = ["10.0.2.0/24"]
  tags                      = var.tags
  frontend_subnet_nsg       = module.network.frontend_nsg_id
  backend_subnet_nsg        = module.network.backend_nsg_id
  firewall_subnet_cidr      = var.firewall_subnet_cidr
  business_unit             = var.business_unit
}

module "keyvault" {
  source                    = "./modules/keyvault"
  environment               = var.environment
  region                    = var.region
  identifier                = "002"
  resource_group_name       = azurerm_resource_group.rg["rg-${var.environment}-shared"].name
  location                  = var.region
  tags                      = var.tags
  tenant_id                 = var.tenant_id
  key_vault_ip_rules        = var.key_vault_ip_rules
  key_vault_vnet_subnet_ids = var.key_vault_vnet_subnet_ids
}

module "monitor" {
  source              = "./modules/monitoring"
  environment         = var.environment
  region              = var.region
  resource_group_name = azurerm_resource_group.rg["rg-${var.environment}-shared"].name
  target_resource_id  = module.network.vnet_id
  tags                = var.tags
}

module "security" {
  source         = "./modules/security"
  security_email = var.security_email
  security_phone = var.security_phone
}
