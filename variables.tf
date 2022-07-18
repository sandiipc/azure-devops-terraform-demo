variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "location" {
  type        = string
  description = "RG location in Azure"
}

variable "virtual_network_name" {
  type        = string
  description = "VNET name in Azure"
}

variable "subnet_name" {
  type        = string
  description = "Subnet name in Azure"
}

variable "public_ip_name" {
  type        = string
  description = "Public IP name in Azure"
}

variable "network_interface_name" {
  type        = string
  description = "NIC name in Azure"
}

variable "windows_vm_name" {
  type        = string
  description = "Windows VM name in Azure"
}

variable "nic_ip_config_name" {
  type        = string
  description = "NIC ip configuration name"
}

variable "private_ip_allocation_method" {
  type        = string
  description = "dynamic private ip address allocation"
}

variable "public_ip_allocation_method" {
  type        = string
  description = "static public ip address allocation"
}

variable "public_ip_sku" {
  type        = string
  description = "standard sku"
}

variable "vmsize" {
  type        = string
  description = "vm size"
}

variable "vm_username" {
  type        = string
  description = "vm user name"
}

variable "vm_password" {
  type        = string
  description = "vm user password"
}

variable "os_disk_name" {
  type        = string
  description = "os disk name"
}

variable "os_disk_caching" {
  type        = string
  description = "os disk caching"
}

variable "storage_acc_type" {
  type        = string
  description = "storage account type"
}

variable "image_publisher" {
  type        = string
  description = "image publisher name"
}

variable "image_offer" {
  type        = string
  description = "image offer name"
}

variable "image_sku" {
  type        = string
  description = "image sku"
}

variable "image_version" {
  type        = string
  description = "image version"
}

variable "storage_name" {
  type        = string
  description = "storage acc name"
}

variable "account_tier" {
  type        = string
  description = "account tier"
}

variable "account_replication_type" {
  type = string
  description = "acc replication type"
}

variable "networkrule" {
  type = list
  description = "list of network rule"
}

variable "nsg_name" {
  type = string
  description = "network security group name"
}