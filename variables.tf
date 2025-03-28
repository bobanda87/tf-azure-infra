variable "environment" {
  description = "The environment (e.g. dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment must be one of the following: dev, staging, prod."
  }
}

variable "region" {
  description = "The region where the resources will be created"
  type        = string
  default     = "norwayeast"

  validation {
    condition     = var.region == "norwayeast"
    error_message = "The region must be 'norwayeast'."
  }
}

variable "resource_group_names" {
  description = "A list of resource group names"
  type        = list(string)
  default = [
    "core",
    "apps",
    "shared",
  ]
}

variable "tenant_id" {
  description = "Tenant id"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "firewall_subnet_cidr" {
  type        = list(string)
  description = "CIDR block for the Azure Firewall subnet."
}

variable "business_unit" {
  description = "A business unit name"
  type        = string
  default     = "bis"
}

variable "security_email" {
  description = "Email address for security notifications"
  type        = string
}

variable "security_phone" {
  description = "Phone number for security notifications"
  type        = string
}

variable "key_vault_ip_rules" {
  description = "List of allowed IP addresses for the Key Vault"
  type        = list(string)
}

variable "key_vault_vnet_subnet_ids" {
  description = "List of subnet IDs allowed to access the Key Vault"
  type        = list(string)
}

variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}

variable "vnet_address_space" {
  description = "Vnet IP address range"
  type        = list(string)
}

variable "frontend_address_prefixes" {
  description = "Frontend subnet IP address range"
  type        = list(string)
}

variable "backend_address_prefixes" {
  description = "Backend subnet IP address range"
  type        = list(string)
}