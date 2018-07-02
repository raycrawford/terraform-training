#!/bin/sh

#############################################################################################
# Test for Homebrew
if [ ! -x "$(command -v brew)" ]; then
   echo "Homebrew is not installed; please install and re-run"
   echo "Run: ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor"
   exit
else
   echo "Homebrew is installed; moving on."
fi

if [ ! -x "$(command -v brew cask)" ]; then
   echo "Homebrew cask is not installed; please install and re-run"
   echo "Run: brew install caskroom/cask/brew-cask"
   exit
else
   echo "Homebrew cask is installed; moving on."
fi

#############################################################################################
# Update repo
brew update

#############################################################################################
# Install Git
if [ ! -x "$(command -v git)" ]; then
   brew install git
fi

#############################################################################################
# Install Docker
if [ ! -x "$(command -v docker)" ]; then
   brew cask install docker
fi

#############################################################################################
# Install the Azure CLI 2.0
if [ ! -x "$(command -v az)" ]; then
   brew install azure-cli
fi
