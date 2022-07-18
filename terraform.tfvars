resource_group_name          = "vm_terraform_rg"
location                     = "West Europe"
virtual_network_name         = "vnetprod"
subnet_name                  = "subnetprod"
public_ip_name               = "publicipprod"
network_interface_name       = "nicprod"
windows_vm_name              = "windows10"
nic_ip_config_name           = "internal"
private_ip_allocation_method = "Dynamic"
public_ip_allocation_method  = "Static"
public_ip_sku                = "Standard"
vmsize                       = "Standard_DS1_v2"
vm_username                  = "schak103"
vm_password                  = "TcsP@ssw0rd@2"
os_disk_name                 = "vmOSDisk"
os_disk_caching              = "ReadWrite"
storage_acc_type             = "Standard_LRS"
image_publisher              = "MicrosoftWindowsDesktop"
image_offer                  = "Windows-10"
image_sku                    = "20h1-pro-g2"
image_version                = "latest"
storage_name = "tf_storage"
account_tier = "Standard"
account_replication_type = "GRS"

networkrule = [
  {
    name                       = "rule1"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"  
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "rule2"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "443"
    destination_port_range     = "*"   
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "rule3"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3389"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
]

nsg_name = "az_nsg"