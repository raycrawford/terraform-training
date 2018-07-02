#!/bin/sh

#############################################################################################
# Install Git
if [ ! -x "$(command -v git)" ]; then
   sudo apt-get install git-core
fi

#############################################################################################
# Install Docker
if [ ! -x "$(command -v docker)" ]; then
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

   sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

   sudo apt-get update

   apt-cache policy docker-ce

   sudo apt-get --assume-yes install -y docker-ce

   sudo usermod -aG docker ${USER}
fi

#############################################################################################
# Install the Azure CLI 2.0
if [ ! -x "$(command -v az)" ]; then
   AZ_REPO=$(lsb_release -cs)
   echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
        sudo tee /etc/apt/sources.list.d/azure-cli.list

   curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
   sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
   sudo apt-get --assume-yes install apt-transport-https
   sudo apt-get update && sudo apt-get install azure-cli
fi
