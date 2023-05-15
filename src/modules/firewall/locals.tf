

locals {
  public_ip_sku = "Standard"
  public_ip_allocation_method = "Static"
  public_ip_zones = [1,2,3]
  firewall_ip_configuration_name = "configuration"
}