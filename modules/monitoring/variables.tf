variable "environment" {
  description = "The deployment environment"
  type        = string
}

variable "region" {
  description = "The Azure region for deployment"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name where resources will be deployed"
  type        = string
}

variable "target_resource_id" {
  description = "The resource to monitor"
  type        = string
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}
