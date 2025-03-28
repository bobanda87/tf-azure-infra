resource "azurerm_security_center_subscription_pricing" "security_pricing" {
  tier          = "Standard"
  resource_type = "CloudPosture"

  extension {
    name = "ContainerRegistriesVulnerabilityAssessments"
  }

  extension {
    name = "AgentlessVmScanning"
    additional_extension_properties = {
      ExclusionTags = "[]"
    }
  }

  extension {
    name = "AgentlessDiscoveryForKubernetes"
  }

  extension {
    name = "SensitiveDataDiscovery"
  }
}

resource "azurerm_security_center_contact" "security_contact" {
  name                = "security_contact_lvl1"
  email               = var.security_email
  phone               = var.security_phone
  alert_notifications = true
  alerts_to_admins    = true
}
