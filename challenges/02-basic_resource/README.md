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

We are also going to assume you've:
* built the terraform container (challenge 01)
* set up your `provider.tf` file and included in in the current directory (challenge 01)
* created an alias to terraform which runs the image with all of the right parameters (challenge 01)

To create this resource, do the following:

```
terraform init  # Do once
terraform plan  # See what terraform is going to do
terraform apply -auto-approve # Make terraform execute the plan
```

With this, check the Azure Portal for execution.  It should be there.

# Importing resources to the plan
Terraform only knows about things terraform created.  If you run a plan, it checks the state of the resources it knows about and ensures they are in the desired stated.  It ignores anything it didn't create.

For example, if a storage account was created in the challenge01-rg and you apply the plan, nothing will change.  If you destroy the plan, the resource group and the storage container in it will be deleted.

To make terraform aware of existing resources, use the import functionality.

## Activity
* Run `terraform apply -auto-approve`
* Create a storage account in the challenge02-rg resource group
* Run `terraform plan` again and notice that it only knows about 1 resource (the resource group) as it says 'No changes.  Infrastructure is up-to-date.'
* Create a storage account in `challenge02-rg` called `cardinaltfchallenge02`
* Update the main.tf file to include the new storage account
```
# Before:
resource "azurerm_resource_group" "02ResourceGroup" {
  name     = "challenge02-rg"
  location = "eastus2"
}
```
```
# After:
resource "azurerm_resource_group" "02ResourceGroup" {
  name     = "challenge02-rg"
  location = "eastus2"
}
resource "azurerm_storage_account" "mainStorage" {
  name                     = "cardinaltfchallenge02"
  resource_group_name      = "${azurerm_resource_group.02ResourceGroup.name}"
  location                 = "eastus2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```
