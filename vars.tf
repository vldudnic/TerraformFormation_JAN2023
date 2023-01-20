variable "location" {
    type = string
    default = "East US"
}

variable "prefix" {
    type = string
    default = "vdudnic"
}

variable "admin_password" {
    type = string
    default = "PassW0rd@123"
}

variable "admin_username" {
    type = string
    default = "adminuser"
}

variable "size" {
    type = string
    default = "Standard_F2"
}

variable "os_disk" {
    type = map
    default = {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
}

variable "source_image_reference" {
    type = map
    default = { 
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }
  }

  variable "address_space" {
    default = ["10.0.0.0/16"]
  }

  variable "address_prefixes" {
    default = ["10.0.2.0/24"]
  } 

  variable "allocation_method" {
    default = "Static"
  }

  variable "private_ip_address_allocation" {
    default = "Dynamic"
  }

  variable "azurerm_public_ip" {
    default = "acceptanceTestPublicIp1"
  }