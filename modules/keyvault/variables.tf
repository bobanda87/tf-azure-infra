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

variable "tags" {
  description = "Tags to assign to the resources"
  type        = map(string)
}

variable "tenant_id" {
  description = "Tenant Id"
  type        = string
}
