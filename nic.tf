resource "azapi_resource" "nic" {
  type = "Microsoft.AzureStackHCI/networkInterfaces@2023-09-01-preview"
  body = {
    extendedLocation = {
      type = "CustomLocation"
      name = var.customLocationId
    }

    properties = {
      ipConfigurations = [{
        name = null
        properties = {
          subnet = {
            id = var.logicalNetworkId
          }
          privateIPAddress = var.privateIPAddress == "" ? null : var.privateIPAddress
        }
      }]
    }
  }
  location  = var.location
  name      = "${var.vmName}-nic"
  parent_id = data.azurerm_resource_group.rg.id
}
