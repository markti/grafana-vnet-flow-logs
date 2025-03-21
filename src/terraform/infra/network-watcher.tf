resource "azurerm_network_watcher" "main" {
  name                = "netw-${var.application_name}-${var.environment_name}-${var.location}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_network_watcher_flow_log" "main" {
  network_watcher_name = azurerm_network_watcher.main.name
  resource_group_name  = azurerm_resource_group.main.name
  name                 = "netw-${var.application_name}-${var.environment_name}-flowlog"

  target_resource_id = azurerm_network_security_group.main.id
  storage_account_id = azurerm_storage_account.logs.id
  enabled            = true

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.main.workspace_id
    workspace_region      = azurerm_log_analytics_workspace.main.location
    workspace_resource_id = azurerm_log_analytics_workspace.main.id
    interval_in_minutes   = 10
  }
}
