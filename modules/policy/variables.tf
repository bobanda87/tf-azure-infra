variable "allowed_regions" {
  description = "List of allowed regions for resource deployment"
  type        = list(string)
  default     = ["norwayeast"]
}
