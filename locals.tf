# TODO: insert locals here.
locals {
  domain_join_password = var.domain_join_password != null ? var.domain_join_password : ""
  dynamic_memory_config_full = var.dynamic_memory ? {
    maximumMemoryMB    = var.dynamic_memory_max
    minimumMemoryMB    = var.dynamic_memory_min
    targetMemoryBuffer = var.dynamic_memory_buffer
    } : {
    maximumMemoryMB    = null
    minimumMemoryMB    = null
    targetMemoryBuffer = null
  }
  dynamic_memory_config_omit_null    = { for k, v in local.dynamic_memory_config_full : k => v if v != null }
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
}
