output "security_center_pricing" {
  description = "The Azure Security Center pricing tier configuration"
  value = {
    tier = azurerm_security_center_subscription_pricing.security_pricing.tier
  }
}