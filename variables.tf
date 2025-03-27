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