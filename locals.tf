# TODO: insert locals here.
locals {
  domain_join_password               = var.domain_join_password != null ? var.domain_join_password : ""
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
}
