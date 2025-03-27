resource "azurerm_network_ddos_protection_plan" "vnet_ddos_protection" {
  name                = "ddos-plan-${var.environment}-${var.region}-${var.identifier}"
  resource_group_name = var.resource_group_name
  location            = var.region
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.environment}-${var.region}-${var.identifier}"
  location            = var.region
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.vnet_ddos_protection.id
    enable = true
  }
}

###
# FRONTEND COMPONENTS
###

resource "azurerm_subnet" "subnet_frontend" {
  name                 = "snet-${var.environment}-${var.region}-frontend-${var.identifier}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.frontend_address_prefixes
}

resource "azurerm_network_security_group" "nsg_frontend" {
  name                = "nsg-weballow-${var.environment}-${var.region}-${var.identifier}"
  location            = var.region
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow_https"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443" # HTTPS
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "deny_all"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_frontend_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet_frontend.id
  network_security_group_id = azurerm_network_security_group.nsg_frontend.id
}

###
# BACKEND COMPONENTS
###

resource "azurerm_subnet" "subnet_backend" {
  name                 = "snet-${var.environment}-${var.region}-backend-${var.identifier}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.backend_address_prefixes
  service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Storage",
    "Microsoft.Sql"
  ]
}

resource "azurerm_network_security_group" "nsg_backend" {
  name                = "nsg-sqlallow-${var.environment}-${var.region}-${var.identifier}"
  location            = var.region
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow_internal"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432" # PostgreSQL
    source_address_prefix      = "10.0.0.0/8"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "deny_all"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_backend_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet_backend.id
  network_security_group_id = azurerm_network_security_group.nsg_backend.id
}

###
# PRIVATE ENDPOINT
###

resource "azurerm_private_endpoint" "stg_private_endpoint" {
  name                = "pe-${var.environment}-${var.region}-${var.identifier}"
  location            = var.region
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.subnet_backend.id

  private_service_connection {
    name                           = "pe-connection-${var.environment}-${var.region}-${var.identifier}"
    private_connection_resource_id = azurerm_storage_account.bis_storage_account_backend.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }
}

resource "azurerm_storage_account" "bis_storage_account_backend" {
  name                            = "stg${var.environment}${var.region}${var.identifier}"
  resource_group_name             = var.resource_group_name
  location                        = var.region
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  is_hns_enabled                  = true
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  tags                            = var.tags

  network_rules {
    default_action             = "Deny"
    bypass                     = ["Logging", "Metrics", "AzureServices"]
    virtual_network_subnet_ids = [azurerm_subnet.subnet_backend.id]
  }
}

###
# AZURE FIREWALL
###

resource "azurerm_public_ip" "firewall_ip" {
  name                = "${var.business_unit}-${var.environment}-pip-azfw-${var.region}"
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.firewall_subnet_cidr
}

resource "azurerm_firewall" "main" {
  name                = "${var.business_unit}-${var.environment}-azfw-${var.region}"
  location            = var.region
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.firewall_ip.id
  }
}
