# Creating a Basic Azure Resource
In this module, we are going to create a basic Azure resource using Terraform and show how to import existing Azure resources into Terraform.

# How Terraform works
When creating new resources, two (primary) Terraform actions are used:
* plan
* apply

To destroy resources, `terraform destroy` is used.

# Creating simple resource
As a first step, create a resource group.  This is defined in Terraform, as follows:
```
resource "azurerm_resource_group" "c02-RG" {
  name     = "challenge02-AZ-RG"
  location = "eastus2"
}
```
