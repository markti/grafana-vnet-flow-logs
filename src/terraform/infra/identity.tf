resource "azurerm_user_assigned_identity" "grafana" {
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = "mi-${var.application_name}-${var.environment_name}-grafana"
}

/*
logws_id=$(az resource show -n $logws_name -g $rg --query id -o tsv)
grafana_principal_id=$(az grafana show -n $grafana_name -g $rg --query identity.principalId -o tsv)
az role assignment create --assignee $grafana_principal_id --role 'Log Analytics Reader' --scope $logws_id -o none
*/
resource "azurerm_role_assignment" "grafana_logs_reader" {
  scope                = azurerm_log_analytics_workspace.main.id
  role_definition_name = "Log Analytics Reader"
  principal_id         = azurerm_user_assigned_identity.grafana.principal_id
}
