resource "azapi_resource" "domain_join" {
  count = length(var.domain_to_join) > 0 ? 1 : 0

  type = "Microsoft.HybridCompute/machines/extensions@2023-10-03-preview"
  body = {
    properties = {
      publisher               = "Microsoft.Compute"
      type                    = "JsonADDomainExtension"
      typeHandlerVersion      = var.type_handler_version
      autoUpgradeMinorVersion = var.auto_upgrade_minor_version
      settings = {
        name    = var.domain_to_join
        OUPath  = var.domain_target_ou
        User    = "${var.domain_to_join}\\${var.domain_join_user_name}"
        Restart = true
        Options = 3
      }
      protectedSettings = {
        Password = local.domain_join_password
      }
    }
  }
  location  = var.location
  name      = "domainJoinExtension"
  parent_id = azapi_resource.hybrid_compute_machine.id
  tags      = var.domain_join_extension_tags

  depends_on = [
    azapi_resource.virtual_machine
  ]
}
