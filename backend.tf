terraform {
   backend "azurerm" {
     resource_group_name  = "vm_terraform_rg"
     storage_account_name = "vm_storage"
     container_name       = "tfstate"
     key                  = "terraform.tfstate"
   }
}