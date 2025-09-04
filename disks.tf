resource "azapi_resource" "data_disks" {
  for_each = var.data_disk_params

  location  = var.location
  name      = each.value.name != "" ? each.value.name : "${var.name}dataDisk${format("%02d", index(var.data_disk_params, each.key) + 1)}"
  parent_id = data.azurerm_resource_group.rg.id
  type      = "Microsoft.AzureStackHCI/virtualHardDisks@2023-09-01-preview"
  body = {
    extendedLocation = {
      name = var.custom_location_id
      type = "CustomLocation"
    }
    properties = {
      diskSizeGB  = each.value.diskSizeGB
      dynamic     = each.value.dynamic
      containerId = each.value.containerId
    }
  }
  create_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  delete_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  read_headers   = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  tags           = each.value.tags
  update_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null

  lifecycle {
    ignore_changes = [
      body.properties.dynamic,
    ]
  }
}
