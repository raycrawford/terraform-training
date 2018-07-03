# Creating a Basic Azure Resource
In this module, we are going to create a basic Azure resource using Terraform and show how to import existing Azure resources into Terraform.

# How Terraform works
When creating new resources, two (primary) Terraform actions are used:
* plan (or apply without `-auto-approve`)
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

## A word about `terraform init`
Terraform is built using a plugin architecture and the individual providers, as of 0.10.0, are their own encapsulated binaries.  When a new infrastructure is created or an existing one is checked out from source control, it is necessary to run `terraform init` in order to get all of the plugins, local settings and data that will be used by subsequent commands loaded into the `.terraform` directory.

This only need to be done once.

## A word about `terraform plan`
As of Terraform 0.11.0, it is no longer necessary to 'plan'.  Instead, exectute `terraform apply`.  This will run "the plan" and prompt for acceptance.  To skip planning, include the `-auto-approve` flag when applying as shown above.

# Importing resources to the plan
Terraform only knows about things terraform created.  If you run a plan, it checks the state of the resources it knows about and ensures they are in the desired stated.  It ignores anything it didn't create.

For example, if a storage account was created in the challenge01-rg and you apply the plan, nothing will change.  If you destroy the plan, the resource group and the storage container in it will be deleted.

To make terraform aware of existing resources, use the import functionality.

## Activity
* Run `terraform apply -auto-approve`
* Create a storage account in the challenge02-rg resource group
* Run `terraform apply` again and notice that it only knows about 1 resource (the resource group) as it says 'No changes.  Infrastructure is up-to-date.'
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

At this point, if you were to run a `terraform apply`, you would see that terraform wants to create a new storage account.  **This is not what we want.**

To keep this from happening, we have to import the new storage account as follows:
```
terraform import azurerm_storage_account.mainStorage /subscriptions/977dadf0-6570-40ff-9e5d-25efc3cfb6cc/resourceGroups/challenge02-rg/providers/Microsoft.Storage/storageAccounts/cardinaltfchallenge02
```
If `terraform apply` is now run, it will state than no new resources need to be created; you've successfully imported a resource that terraform didn't previously know about.

# Cleaning up
Now, to be tidy, the provisioned resources need to be 'destroyed'.  This is done using `terraform destroy -auto-aprrove`.  That should be all that is necessary.

# Resources
* The [AzureRM Provider documentation](https://www.terraform.io/docs/providers/azurerm/index.html)
