#!/bin/bash

## https://servian.dev/terraform-local-providers-and-registry-mirror-configuration-b963117dfffa
## https://www.terraform.io/docs/cli/config/config-file.html#provider-installation

PLUGIN_DIR=$HOME/.terraform.d/plugins/local.providers/local/terratowns/1.0.0
PLUGIN_NAME=terraform-provider-terratowns_v1.0.0

cd $PROJECT_ROOT/terraform-provider-terratowns
cp $PROJECT_ROOT/terraformrc $HOME/.terraformrc
rm -rf $HOME/.terraform.d/plugins/
rm -rf $PROJECT_ROOT/.terraform
rm -rf $PROJECT_ROOT/.terraform.lock.hcl

go build -o $PLUGIN_NAME

# Create directories if they don't exist
mkdir -p $PLUGIN_DIR/linux_amd64
mkdir -p $PLUGIN_DIR/x86_64-apple-darwin
mkdir -p $PLUGIN_DIR/x86_64

# Copy binary to all directories
for dir in linux_amd64 x86_64-apple-darwin x86_64; do
    cp $PLUGIN_NAME $PLUGIN_DIR/$dir
done
