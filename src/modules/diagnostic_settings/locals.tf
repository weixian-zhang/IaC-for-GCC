
locals {
  # get resource name used for diagnostic settings name
  resource_names_from_ids = [ for rid in var.resource_ids : element(split("/", rid), length(lsplit("/", rid)) - 1)  ]
}