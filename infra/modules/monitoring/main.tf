data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}


resource "azurerm_monitor_workspace" "azure_monitor" {

  name = "${var.name_prefix}-azure-monitor"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location

}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name = "${var.name_prefix}-log-analytics"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_dashboard_grafana" "grafana" {
  name = "${var.name_prefix}-grafana"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location

  grafana_major_version = var.grafana_version

  identity {
    type = "SystemAssigned"
  }
  azure_monitor_workspace_integrations {
    resource_id = azurerm_monitor_workspace.azure_monitor.id
  }
}

resource "azurerm_role_assignment" "monitor_access" {
  scope                = azurerm_monitor_workspace.azure_monitor.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.grafana.identity.0.principal_id
}

resource "azurerm_role_assignment" "log_analytics_access" {
  scope                = azurerm_log_analytics_workspace.log_analytics.id
  role_definition_name = "Log Analytics Reader"
  principal_id         = azurerm_dashboard_grafana.grafana.identity.0.principal_id
}

resource "azurerm_monitor_data_collection_rule" "machine_dcr" {
  name = "${var.name_prefix}-machine-dcr"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-Perf", "Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers            = ["\\VmInsights\\DetailedMetrics"]
      name                          = "VMInsightsPerfCounters"
    }
  }
  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["destination-metrics"]
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["destination-logs"]
  }

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.log_analytics.id
      name                  = "destination-logs"
    }

    azure_monitor_metrics {
      name = "destination-metrics"
    }
  }
}

resource "azurerm_monitor_data_collection_rule_association" "example" {
  for_each = var.vm_ids
  name = "${var.name_prefix}-machines-dcr-association"
  data_collection_rule_id = azurerm_monitor_data_collection_rule.machine_dcr.id
  target_resource_id      = each.value
}
