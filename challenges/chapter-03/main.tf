resource "azurerm_resource_group" "03ResourceGroup" {
  name     = "chapter03-rg"
  location = "eastus2"
}
resource "azurerm_storage_account" "osStorage" {
  name                     = "cardinaltfoschapter03"
  resource_group_name      = "${azurerm_resource_group.03ResourceGroup.name}"
  location                 = "eastus2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_container" "osStorageContainer" {
  name                  = "vhds"
  resource_group_name   = "${azurerm_resource_group.03ResourceGroup.name}"
  storage_account_name  = "${azurerm_storage_account.osStorage.name}"
  container_access_type = "private"
}

resource "azurerm_storage_account" "otherStorage" {
  name                     = "cardinaltfotherchapter03"
  resource_group_name      = "${azurerm_resource_group.03ResourceGroup.name}"
  location                 = "eastus2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_network" "03VirtualNetwork" {
  name                = "cardinaltfvnchapter03"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.03ResourceGroup.location}"
  resource_group_name = "${azurerm_resource_group.03ResourceGroup.name}"
}

resource "azurerm_subnet" "03Subnet" {
  name                 = "cardinaltfsnchapter03"
  resource_group_name  = "${azurerm_resource_group.03ResourceGroup.name}"
  virtual_network_name = "${azurerm_virtual_network.03VirtualNetwork.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "03NetworkInterface" {
  name                = "acctni"
  location            = "${azurerm_resource_group.03ResourceGroup.location}"
  resource_group_name = "${azurerm_resource_group.03ResourceGroup.name}"

  ip_configuration {
    name                          = "ipconf01"
    subnet_id                     = "${azurerm_subnet.03Subnet.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "03VirtualMachine" {
  name                  = "acctvm"
  location              = "${azurerm_resource_group.03ResourceGroup.location}"
  resource_group_name   = "${azurerm_resource_group.03ResourceGroup.name}"
  network_interface_ids = ["${azurerm_network_interface.03NetworkInterface.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "myosdisk1"
    vhd_uri       = "${azurerm_storage_account.osStorage.primary_blob_endpoint}${azurerm_storage_container.osStorageContainer.name}/myosdisk1.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  # Optional data disks
  storage_data_disk {
    name          = "datadisk0"
    vhd_uri       = "${azurerm_storage_account.osStorage.primary_blob_endpoint}${azurerm_storage_container.osStorageContainer.name}/datadisk0.vhd"
    disk_size_gb  = "1023"
    create_option = "Empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "staging"
  }

  depends_on = ["azurerm_storage_container.otherStorageContainer"]
}

resource "azurerm_storage_container" "otherStorageContainer" {
  name                  = "stuff"
  resource_group_name   = "${azurerm_resource_group.03ResourceGroup.name}"
  storage_account_name  = "${azurerm_storage_account.otherStorage.name}"
  container_access_type = "private"
}
