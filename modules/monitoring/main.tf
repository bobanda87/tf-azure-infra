resource "azurerm_log_analytics_workspace" "monitor_workspace" {
  name                = "monitor-${var.environment}-${var.region}"
  location            = var.region
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "monitor_diagnostic" {
  name                       = "diag-${var.environment}-${var.region}"
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.monitor_workspace.id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  metric {
    category = "AllMetrics"
  }
}
