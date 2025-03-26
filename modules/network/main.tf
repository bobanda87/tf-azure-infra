resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.environment}-${var.region}-${var.identifier}"
  location            = var.region
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  tags = var.tags
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

# resource "azurerm_private_endpoint" "stg_private_endpoint" {
#   name                = "pe-${var.environment}-${var.region}-${var.identifier}"
#   location            = var.region
#   resource_group_name = var.resource_group_name
#   subnet_id           = azurerm_subnet.subnet_backend.id

#   private_service_connection {
#     name                           = "pe-connection-${var.environment}-${var.region}-${var.identifier}"
#     private_connection_resource_id = var.storage_account_id
#     subresource_names              = ["blob"]
#     is_manual_connection           = false
#   }

#   tags = var.tags
# }

# resource "azurerm_storage_account" "storage_account" {
#   name                     = "stg${var.environment}${var.region}-${var.identifier}"
#   resource_group_name      = var.resource_group_name
#   location                 = var.region
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   tags = var.tags
# }
