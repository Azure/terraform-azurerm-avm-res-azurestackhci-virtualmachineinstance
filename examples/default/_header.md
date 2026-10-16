# Default example

This deploys the module in its simplest form.

An existing Azure Local cluster is required, with a custom location, VM image,
logical network, and resource group in the target subscription. Set
`ARM_SUBSCRIPTION_ID` to that subscription and supply `custom_location_name`,
`image_name`, `logical_network_name`, `resource_group_name`, `name`, and
`vm_admin_password` through your own Terraform inputs. Keep passwords out of
committed files.

These prerequisites are also required for an automated policy plan. This example
does not provision the cluster, image, or logical network; invented names or
placeholder credentials cannot replace a configured test lab.
