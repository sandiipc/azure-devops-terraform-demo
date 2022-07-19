resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}


#------------------------------------------------------###################
# VNET & Subnets
#------------------------------------------------------###################

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  resource_group_name = var.resource_group_name
  location            = var.location

  dynamic "security_rule" {
    iterator = rule
    for_each = var.networkrule
    content {
      name                       = rule.value.name
      priority                   = rule.value.priority
      direction                  = rule.value.direction
      access                     = rule.value.access
      protocol                   = rule.value.protocol
      source_port_range          = rule.value.source_port_range
      destination_port_range     = rule.value.destination_port_range
      source_address_prefix      = rule.value.source_address_prefix
      destination_address_prefix = rule.value.destination_address_prefix

    }
  }

  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name

  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.0.0/24"]

  depends_on = [
    azurerm_resource_group.rg, azurerm_virtual_network.vnet
  ]
}

# resource "azurerm_subnet_network_security_group_association" "subnet_nsgrule" {
#   subnet_id                 = azurerm_subnet.subnet.id
#   network_security_group_id = azurerm_network_security_group.nsgrule.id

#   depends_on = [
#     azurerm_subnet.subnet, azurerm_network_security_group.nsgrule
#   ]
# }

# resource "azurerm_subnet" "bastion" {
#   name                 = "AzureBastionSubnet"
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = var.virtual_network_name
#   address_prefixes     = ["10.0.1.0/27"]
# }

#------------------------------------------------------###################
# VM for BASTION
#------------------------------------------------------###################

resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku

  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_network_interface" "nic" {
  name                = var.network_interface_name
  location            = var.location
  resource_group_name = var.resource_group_name
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"

  ip_configuration {
    name                          = var.nic_ip_config_name
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = var.private_ip_allocation_method
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  depends_on = [
    azurerm_resource_group.rg, azurerm_network_security_group.nsg
  ]
}

# resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
#   network_interface_id      = azurerm_network_interface.nic.id
#   network_security_group_id = azurerm_network_security_group.nsgrule.id
# }

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = var.windows_vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vmsize
  admin_username        = var.vm_username
  admin_password        = var.vm_password

  os_disk {
    name                 = var.os_disk_name
    caching              = var.os_disk_caching
    storage_account_type = var.storage_acc_type
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
  depends_on = [
    azurerm_resource_group.rg
  ]
}

#------------------------------------------------------###################
# BASTION
#------------------------------------------------------###################

# resource "azurerm_public_ip" "bastion" {
#   name                = "bastionip"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_bastion_host" "bastion" {
#   name                = "bastion"
#   location            = var.location
#   resource_group_name = var.resource_group_name

#   ip_configuration {
#     name                 = "configuration"
#     subnet_id            = azurerm_subnet.bastion.id
#     public_ip_address_id = azurerm_public_ip.bastion.id
#   }
# }

#--------------------------------------------------------------------------
# Install tools in Bastion VM
#--------------------------------------------------------------------------

// resource "azurerm_virtual_machine_extension" "extension" {
//   name                 = "k8s-tools-deploy"
//   virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
//   publisher            = "Microsoft.Azure.Extensions"
//   type                 = "CustomScript"
//   type_handler_version = "1.9.5" # "2.0"

//   settings = <<SETTINGS
//     {
//         "script": "hostname"
//     }
// SETTINGS

// //   settings = <<SETTINGS
// //     {
// //         "script": "hostname"
// //         # "commandToExecute": "hostname"
// //     }
// // SETTINGS
// }

// resource "azurerm_virtual_machine_extension" "extension" {
//   name                 = "k8s-tools-deploy01"
//   virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
//   publisher            = "Microsoft.Compute"
//   type                 = "CustomScriptExtension"
//   type_handler_version = "1.9.5" # "2.0"

//   settings = <<SETTINGS
//     {
//         "script": "hostname"
//     }
// SETTINGS

// //   settings = <<SETTINGS
// //     {
// //         "script": "hostname"
// //         # "commandToExecute": "hostname"
// //     }
// // SETTINGS
// }

# # Install Azure CLI
# Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
#
# # Install chocolately
# Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#
# # Install Kubernetes CLI
# choco install kubernetes-cli
#
# # Install Helm CLI
# choco install kubernetes-helm