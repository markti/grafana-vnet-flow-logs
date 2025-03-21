
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.location
}

/*

Creates a Azure Managed Grafana (AMG)

Replaces the following Azure CLI commands:

```
    az grafana create -n $grafana_name -g $rg -l $location -o none
    grafana_url=$(az grafana show -n $grafana_name -g $rg -o tsv --query properties.endpoint)
    echo "Grafana URL is $grafana_url"
```

*/
resource "azurerm_dashboard_grafana" "main" {
  name                              = "amg-tsg-${var.environment_name}"
  resource_group_name               = azurerm_resource_group.main.name
  location                          = azurerm_resource_group.main.location
  grafana_major_version             = 10
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = true
  zone_redundancy_enabled           = false

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.grafana.id
    ]
  }
}

/*
Set the current user as Grafana Admin

Replaces the following Azure CLI commands:

```
    my_user_id=$(az ad signed-in-user show --query id -o tsv)
    grafana_id=$(az grafana show -n $grafana_name -g $rg --query id -o tsv)
    az role assignment create --assignee $my_user_id --role 'Grafana Admin' --scope $grafana_id -o none
```

*/
resource "azurerm_role_assignment" "grafana_admin" {
  scope                = azurerm_dashboard_grafana.main.id
  role_definition_name = "Grafana Admin"
  principal_id         = data.azurerm_client_config.current.object_id
}
