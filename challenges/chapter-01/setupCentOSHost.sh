#!/usr/bin/sh

#############################################################################################
# Install Git
if [ ! -x "$(command -v git)" ]; then
   sudo yum install git -y
fi

#############################################################################################
# Install Docker
if [ ! -x "$(command -v docker)" ]; then
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install docker-ce -y
    sudo systemctl start docker
    sudo usermod -aG docker ${USER}
fi

#############################################################################################
# Install the Azure CLI 2.0
if [ ! -x "$(command -v az)" ]; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
    sudo yum install azure-cli -y
fi
