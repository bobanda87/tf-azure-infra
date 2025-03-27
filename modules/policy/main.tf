data "azurerm_subscription" "current" {}

resource "azurerm_policy_definition" "restrict_regions" {
  name         = "restrict-resource-regions"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Restrict Resource Deployment to Allowed Regions"

  parameters = <<PARAMETERS
{
  "allowedRegions": {
    "type": "Array",
    "defaultValue": ["norwayeast"],
    "metadata": {
      "description": "The list of allowed regions"
    }
  }
}
PARAMETERS

  policy_rule = <<POLICY_RULE
{
    "if": {
      "not": {
        "field": "location",
        "in": "[parameters('allowedRegions')]"
      }
    },
    "then": {
      "effect": "Deny"
    }
}
POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "assign_restrict_regions" {
  name                 = "restrict-resource-regions-assignment"
  policy_definition_id = azurerm_policy_definition.restrict_regions.id
  subscription_id      = data.azurerm_subscription.current.id

  parameters = jsonencode({
    allowedRegions = {
      "value" : var.allowed_regions
    }
  })
}