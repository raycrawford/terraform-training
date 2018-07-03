# Handing resource dependencies
In the prior chapter, a dependencies were introduced.  Many times, resources can not be provisioned in parallel because one resource (a VM for example), depends on another (the storage account where its OS and data drives are stored).  Consider the example from the last chapter.

```
resource "azurerm_resource_group" "02ResourceGroup" {
  name     = "chapter02-rg"
  location = "eastus2"
}
resource "azurerm_storage_account" "mainStorage" {
  name                     = "cardinaltfchapter02"
  resource_group_name      = "${azurerm_resource_group.02ResourceGroup.name}"
  location                 = "eastus2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

# Implict dependencies
The example above shows *implicit* dependency.  The storage account depends on the existance of the Resource Group.  Otherwise, it could not be provisioned.  VMs/storage accounts and VMs/static IPs have similar dependencies.  Terraform maps these dependencies and provisions the resources in the appropriate order.

# Explicit dependencies
There are cases where terraform can not know.  For example, if you provision a VM, the drives that the particular VM depends on will be **implicit** dependencies.  However, if that VM, post provisioning, relies on files on another storage account, there is no way for terraform to know about that dependency through implicit relationships.  In cases such as this, **explicit** dependency declaration is needed.

For example, look at the `main.tf` file in this directory.  Even though the resource `azurerm_storage_container.otherStorageContainer` is defined after the VM, the VM won't be provisioned until after the Container is provisioned.  This is an **explicit** dependency due to the `depends_on = ["azurerm_storage_container.otherStorageContainer"]`.  On the other hand, the relationship between the *Storage Account Container* and the *Storage Account* is considered an **implict** dependency and is one that terraform will figure out on its own.