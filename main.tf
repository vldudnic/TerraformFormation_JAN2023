terraform {
#  backend "local" {
#    path = "C:\\Users\\vdudnic\\Documents\\_1Alstom\\AZURE\\TerraformFormation_JAN2023\\tfstates\\cb.tfstate"
#  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.38.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id             = var.subscription_id
  client_id                   = var.client_id
  client_certificate_path     = var.client_certificate_path
  tenant_id                   = var.tenant_id
}

resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-vn"
  address_space       = var.address_space
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "${var.prefix}-sn"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = var.address_prefixes
}

resource "azurerm_public_ip" "example" {
  name                = var.azurerm_public_ip
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = var.allocation_method
}

resource "azurerm_network_security_group" "example" {
  name                = "${var.prefix}-sg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "${var.prefix}-sg-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80-443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "${var.prefix}-sg-ssh"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_network_interface" "example" {
  name                = "${var.prefix}-ni"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "${var.prefix}-ipc"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "${var.prefix}-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  disable_password_authentication       = false
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  boot_diagnostics {
    
  }

    provisioner "remote-exec" {
      connection {
       type = "ssh"
       user = var.admin_username
       password = var.admin_password
       host = self.public_ip_address
     }
     inline = [
       "sudo apt update",
       "sudo apt -y install apache2",
       "sudo systemctl start apache2",
       "echo '<!doctype html><html><body><h1>Hello if you see this than you have apache running!</h1></body></html>' | sudo tee /var/www/html/index.htm",
       "exit"
     ]
  }
}  
resource "null_resource" "mynullresource" {
  provisioner "local-exec" {
    command = "echo Runningfrom null resource"
  }
}


