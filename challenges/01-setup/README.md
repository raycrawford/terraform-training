# Getting Started
In this module, we are going to get our host setup.  The following packages should be installed:

* git (just for good measure)
* Azure CLI
* Docker

Once the above dependencies are set up, a recent build of the dockerized Terraform will be built on the VM.

# Setup host machine
The following scripts will install the necessary dependencies on the workstation/VM on which you will be doing your Terraform development.  Pick the appropriate one:

* setupMacOSHost.sh
* setupCentOSHost.sh
* setupUbuntuHost.sh

If a Windows host is being used, install the above dependencies, manually.

# Build Terraform image
We will be using Terraform in a container.  To do this:
* Copy [Terraform docker file from here](https://hub.docker.com/r/hashicorp/terraform/~/dockerfile/), locally
* Execute a `docker build . --tag terraform`
* Test and find out most recent version using `docker run -i -t terraform -v`
* If when run, a more recent version of Terraform is available, update Dockerfile `ENV TERRAFORM_VERSION=` and run `docker rmi terraform && docker build . --tag terraform`

The most recent version of terraform is now available in a container tagged "terraform" which can be executed at any time using `docker run -i -t terraform [command]`.

# Log into Azure and set subscription
```
az login
az account list -o table
Name                              CloudName    SubscriptionId                        State    IsDefault
--------------------------------  -----------  ------------------------------------  -------  -----------
Pay-As-You-Go                     AzureCloud   12345678-3210-3456-2345-901234567890  Enabled  True
Visual Studio Ultimate with MSDN  AzureCloud   87654321-0123-6543-5432-098765432109  Enabled  False
az account set --subscription 87654321-0123-6543-5432-098765432109
az account list -o table
Name                              CloudName    SubscriptionId                        State    IsDefault
--------------------------------  -----------  ------------------------------------  -------  -----------
Pay-As-You-Go                     AzureCloud   12345678-3210-3456-2345-901234567890  Enabled  False
Visual Studio Ultimate with MSDN  AzureCloud   87654321-0123-6543-5432-098765432109  Enabled  True
