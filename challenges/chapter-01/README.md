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
* Use the Dockerfile in this directory; it's very similar to the [Terraform Dockerfile](https://hub.docker.com/r/hashicorp/terraform/~/dockerfile/) but it sets some additional variables to help with abstraction
* Execute a `docker build . --tag terraform`
* Test and find out most recent version using `docker run -i -t terraform -v`
* If when run, a more recent version of Terraform is available, update Dockerfile `ENV TERRAFORM_VERSION=` and run `docker rmi terraform && docker build . --tag terraform`

The most recent version of terraform is now available in a container tagged "terraform".  Because the container must run as a user who can update the Azure fabric, tfApply.sh and tfDestroy.sh scripts are available in the next directory to demonstrate abstraction.

## Rapid iteration of Dockerfile & secrets
Once the terraform image has been built, it may need to be rebuilt (different version, different arguements, etc.).  This takes several minutes each iteration.

To expedite this process, leverage caching by only deleting the final necessary layer(s) before rebuilding.  For example, if only the version is being updated, the final layer can be deleted and rebuilt using the following:

```
docker rmi terraform --no-prune
docker build . --tag terraform
```

# Executing `terraform` and managing secrets
This new terraform image will be instantiated into a new container, each time, with a very specific purpose (init, plan, apply, etc.).  With each invocation, since the resulting container will be doing *stuff* on the Azure Fabric, credentials must be passed to enable this.

Two ways have been devised to do this; pick the one that meets your security needs best.

## Option 1
A "provider.tf" can be created in the working directory that looks like (see provider.tf.template in repo root):
```
provider "azurerm" {
    tenant_id = "xxxx"
    subscription_id = "xxxx"
    client_id = "xxxx"
    client_secret = "xxxx"
}
```

The Service Principal will be created in the next step, but for now, focus on the credentials.  So long as this file is in the working directory, it will be loaded with all of the other *.tf files and will be used to authenticate to the provider(s).

In to do a terraform apply, one would simply run:

```
docker run -v `pwd`:/app -w /app/ terraform apply
```
This could even be further simplified by adding the following alias to the active shell:

```
alias terraform='docker run -v `pwd`:/app -w /app/ terraform'
```

This runs the terraform image, mounts the current directory to /app in the container, sets that as the working directory for the container command which is `terraform` in this case and passes the following arguments (`apply` in this case).

## Option 2
In your particular situation, it may not be desirable to store the credentials on disk.  In that case, they can be passed as command-line arguments to Docker which then injects them into the running container.

For an example of this approach, see `myCreds.secret.sh.template`.  In the specific implementation, if the build tool (Jenkins, for example) were given a Service Principal and the Azure CLI or PowerShell Core with the Azure Extensions is installed, the command-line variables could be pulled from a key vault rather than being hard-coded in the myCreds.secret.sh file.

Either way, as written for this example, terraform then would be executed via:
```
. ../myCreds.secret.sh # Run once per shell instance

docker run `echo $ARGS` terraform apply # or init|plan|destroy
```

# Creating Service Principal
This is a pretty straight forward and well documented process, included here just for simplicity.  This example assumes that the values in `../myCreds.secret.sh` have been populated:
```
. ../myCreds.secret.txt

az login
az account set --subscription $SUBSCRIPTIONID
appID=$(az ad sp create-for-rbac --name terraform --password $PASSWORD | jq ".appId" -r)
az role assignment create --assignee $appID --role Contributor --scope /subscriptions/${ARM_SUBSCRIPTION_ID}

echo "Client ID = ${appID}"
```
The client appID is then placed in `myCreds.secret.sh` and/or `provider.tf`.
