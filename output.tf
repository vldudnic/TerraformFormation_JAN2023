output "PrivateIP" {
  value = "IP: ${azurerm_linux_virtual_machine.example.private_ip_address} Username: ${azurerm_linux_virtual_machine.example.admin_username}"
}

output "osdisk" {
  value = azurerm_linux_virtual_machine.example.os_disk[0].disk_size_gb
}

output "PublicIP" {
    value = azurerm_public_ip.example.ip_address
}

output "Password" {
    value = azurerm_linux_virtual_machine.example.admin_password
    sensitive = true
}

output "SKU" {
    value = azurerm_linux_virtual_machine.example.source_image_reference[0].sku
}