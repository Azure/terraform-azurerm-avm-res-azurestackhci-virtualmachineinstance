resource "azapi_resource" "data_disks" {
  count = length(var.data_disk_params)

  type = "Microsoft.AzureStackHCI/virtualHardDisks@2023-09-01-preview"
  body = {
    extendedLocation = {
      name = var.custom_location_id
      type = "CustomLocation"
    }
    properties = {
      diskSizeGB = var.data_disk_params[count.index].diskSizeGB
      dynamic    = var.data_disk_params[count.index].dynamic
      // containerId: uncomment if you want to target a specific CSV/storage path in your HCI cluster
    }
  }
  location  = var.location
  name      = "${var.name}dataDisk${format("%02d", count.index + 1)}"
  parent_id = data.azurerm_resource_group.rg.id
}
