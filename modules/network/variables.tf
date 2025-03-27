variable "environment" {
  description = "The environment for this deployment"
  type        = string
}

variable "region" {
  description = "The Azure region for resources"
  type        = string
}

variable "identifier" {
  description = "Unique identifier for the resource (e.g., 001)"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of resources"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}

variable "frontend_address_prefixes" {
  description = "The address prefixes for the frontend subnet"
  type        = list(string)
}

variable "backend_address_prefixes" {
  description = "The address prefixes for the backend subnet"
  type        = list(string)
}

variable "tags" {
  description = "Tags to assign to the resources"
  type        = map(string)
}

variable "frontend_subnet_nsg" {
  description = "Network Security Group for frontend subnet"
  type        = string
}

variable "backend_subnet_nsg" {
  description = "Network Security Group for backend subnet"
  type        = string
}

variable "vnet_subnet_prefixes" {
  description = "The subnet prefixes in the virtual network"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "subnet_names" {
  description = "List of subnet names"
  type        = list(string)
  default     = ["frontend", "backend"]
}

variable "business_unit" {
  description = "A business unit name"
  type        = string
}

variable "firewall_subnet_cidr" {
  type        = list(string)
  description = "CIDR block for the Azure Firewall subnet."
}
