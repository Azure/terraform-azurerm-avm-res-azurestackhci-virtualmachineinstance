resource "azapi_resource" "nic" {
  type = "Microsoft.AzureStackHCI/networkInterfaces@2023-09-01-preview"
  body = {
    extendedLocation = {
      type = "CustomLocation"
      name = var.custom_location_id
    }

    properties = {
      ipConfigurations = [{
        properties = {
          subnet = {
            id = var.logical_network_id
          }
          privateIPAddress = var.private_ip_address == "" ? null : var.private_ip_address
        }
      }]
      macAddress = null
    }
  }
  location  = var.location
  name      = "${var.name}-nic"
  parent_id = data.azurerm_resource_group.rg.id
  tags      = var.nic_tags

  lifecycle {
    ignore_changes = [
      body.properties.ipConfigurations[0].name,
      body.properties.ipConfigurations[0].properties.privateIPAddress,
      body.properties.macAddress,
    ]
  }
}
