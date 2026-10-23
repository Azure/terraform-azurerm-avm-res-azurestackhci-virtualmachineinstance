# Multiple VM provisioning example

This deploys multiple VMs each with different image.

An existing Azure Local cluster is required, with a custom location and resource
group in the target subscription. Set `ARM_SUBSCRIPTION_ID` to that subscription
and supply `custom_location_name`, `resource_group_name`, and `vm_admin_password`
through your own Terraform inputs. Keep passwords out of committed files. Update
`local.virtual_machines` with the names of images and logical networks already
available in that cluster.

These prerequisites are also required for an automated policy plan. This example
does not provision the cluster, images, or logical networks; invented names or
placeholder credentials cannot replace a configured test lab.
