resource "azapi_resource" "domain_join" {
  count = length(var.domainToJoin) > 0 ? 1 : 0

  type = "Microsoft.HybridCompute/machines/extensions@2023-10-03-preview"
  body = {
    properties = {
      publisher               = "Microsoft.Compute"
      type                    = "JsonADDomainExtension"
      typeHandlerVersion      = "1.3"
      autoUpgradeMinorVersion = true
      settings = {
        name    = var.domainToJoin
        OUPath  = var.domainTargetOu
        User    = "${var.domainToJoin}\\${var.domainJoinUserName}"
        Restart = true
        Options = 3
      }
      protectedSettings = {
        Password = var.domainJoinPassword
      }
    }
  }
  location  = var.location
  name      = "domainJoinExtension"
  parent_id = azapi_resource.hybrid_compute_machine.id

  depends_on = [
    azapi_resource.virtual_machine
  ]
}
