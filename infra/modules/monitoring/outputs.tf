output "default_data_collection_rule_id" {
  description = "Default Data Collection Rule ID used for Prometheus Metric Ingestion"
  value = azurerm_monitor_workspace.azure_monitor.default_data_collection_rule_id
}
