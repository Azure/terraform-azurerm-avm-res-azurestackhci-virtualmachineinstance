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
  virtual_machine_osProfile = {
    computerName = var.name
    linuxConfiguration = {
      ssh = var.linux_ssh_config == null ? {} : var.linux_ssh_config
    }
    windowsConfiguration = {
      provisionVMAgent       = true
      provisionVMConfigAgent = true
      ssh                    = var.windows_ssh_config == null ? {} : var.windows_ssh_config
    }
    adminUsername = var.admin_username
    adminPassword = var.admin_password
  }
  virtual_machine_properties_all = merge(
    nonsensitive(local.virtual_machine_properties_omit_null),
    {
      osProfile = local.virtual_machine_osProfile
    }
  )
  virtual_machine_properties_omit_null = { for key, value in local.virtual_machine_properties_without_auth : key => value if value != null }
  virtual_machine_properties_without_auth = {
    hardwareProfile = {
      vmSize              = "Custom"
      processors          = var.v_cpu_count
      memoryMB            = var.memory_mb
      dynamicMemoryConfig = length(keys(local.dynamic_memory_config_omit_null)) == 0 ? null : local.dynamic_memory_config_omit_null
    }
    httpProxyConfig = var.http_proxy == null && var.https_proxy == null ? null : {
      httpProxy  = var.http_proxy
      httpsProxy = var.https_proxy
      noProxy    = var.no_proxy
      trustedCa  = var.trusted_ca
    }
    securityProfile = {
      uefiSettings = {
        secureBootEnabled = var.secure_boot_enabled
      }
    }
    storageProfile = {
      vmConfigStoragePathId = var.user_storage_id == "" ? null : var.user_storage_id
      imageReference = {
        id = var.image_id
      }
      dataDisks = [for key, value in azapi_resource.data_disks : {
        id = value.id
      }]
      osDisk = {
        osType = var.os_type
      }
    }
    networkProfile = {
      networkInterfaces = [
        {
          id = azapi_resource.nic.id
        }
      ]
    }
  }
}
