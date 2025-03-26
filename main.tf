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
}
