FROM golang:alpine
MAINTAINER "HashiCorp Terraform Team <terraform@hashicorp.com>"

ENV TERRAFORM_VERSION=0.11.7

RUN apk add --update git bash openssh

ENV TF_DEV=true
ENV TF_RELEASE=true

WORKDIR $GOPATH/src/github.com/hashicorp/terraform
RUN git clone https://github.com/hashicorp/terraform.git ./ && \
    git checkout v${TERRAFORM_VERSION} && \
    /bin/bash scripts/build.sh

WORKDIR $GOPATH

ENV ARM_TENANT_ID=setTheTenantIDinDockerRun
ENV ARM_SUBSCRIPTION_ID=setTheSubscriptionIDinDockerRun
ENV ARM_CLIENT_ID=setTheAppIDinDockerRun
ENV ARM_CLIENT_SECRET=setTheSecretinDockerRun

ENTRYPOINT ["terraform"]
