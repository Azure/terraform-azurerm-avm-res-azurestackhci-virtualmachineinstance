resource "azapi_resource" "data_disks" {
  for_each = var.data_disk_params

  type = "Microsoft.AzureStackHCI/virtualHardDisks@2023-09-01-preview"
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
  location  = var.location
  name      = each.value.name != "" ? each.value.name : "${var.name}dataDisk${format("%02d", index(var.data_disk_params, each.key) + 1)}"
  parent_id = data.azurerm_resource_group.rg.id
  tags      = each.value.tags

  lifecycle {
    ignore_changes = [
      body.properties.dynamic,
    ]
  }
}
