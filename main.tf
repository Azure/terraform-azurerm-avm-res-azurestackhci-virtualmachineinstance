data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# required AVM resources interfaces
resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = azapi_resource.virtual_machine.id
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = azapi_resource.virtual_machine.id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

resource "azapi_resource" "hybrid_compute_machine" {
  type = "Microsoft.HybridCompute/machines@2023-10-03-preview"
  body = {
    kind       = "HCI",
    properties = null,
  }
  location  = var.location
  name      = var.name
  parent_id = data.azurerm_resource_group.rg.id
  tags      = var.tags

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      body.properties,
      identity[0].identity_ids,
    ]
  }
}

resource "azapi_resource" "virtual_machine" {
  type = "Microsoft.AzureStackHCI/virtualMachineInstances@2023-09-01-preview"
  body = {
    extendedLocation = {
      type = "CustomLocation"
      name = var.custom_location_id
    }
    properties = local.virtual_machine_properties_final
  }
  name      = "default" # value must be 'default' per 2023-09-01-preview
  parent_id = azapi_resource.hybrid_compute_machine.id

  timeouts {
    create = "2h"
  }

  lifecycle {
    ignore_changes = [
      body.properties.storageProfile.vmConfigStoragePathId,
    ]
  }
}
