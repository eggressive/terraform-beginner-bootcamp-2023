# <div style="text-align:center">Terraform Beginner Bootcamp 2023 - Week 0 :school_satchel: </div>

## Table of Contents

- [Semantic versioning](#semantic-versioning-mage)
- [Install terraform CLI](#install-terraform-cli-floppy_disk)
  - [Reason for the Terraform CLI update](#reason-for-the-terraform-cli-update)
  - [Fixed gpg deprecation issue](#fixed-gpg-deprecation-issue)
- [Env vars](#env-vars-capital_abcd)
  - [Persisting env vars in Gitpod](#persisting-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation-cloud)
- [Terraform Basics](#terraform-basics)
  - [Terraform registry](#terraform-registry)
  - [Terraform console](#terraform-console)
    - [`terraform init`](#terraform-init)
    - [`terraform plan`](#terraform-plan)
    - [`terraform apply`](#terraform-apply)
    - [`terraform destroy`](#terraform-destroy)
    - [`terraform validate`](#terraform-validate)
  - [Terraform lock file `terraform.lock.hcl`](#terraform-lock-file-terraformlockhcl)
  - [Terraform state file `terraform.tfstate`](#terraform-state-file-terraformtfstate)
  - [Terraform directory `.terraform`](#terraform-directory-terraform)
  - [Issue with Terraform Cloud login in Gitpod](#issue-with-terraform-cloud-login-in-gitpod)
    - [Automation of Terraform Cloud login](#automation-of-terraform-cloud-login)
      - [Set env vars](#set-env-vars)
      - [Create bash script in `bin/tflogin.sh`](#create-bash-script-in-bintfloginsh)
    - [Setting TF_VAR to override settings in aws provider](#setting-tf_var-to-override-settings-in-aws-provider)


## Semantic versioning :mage:

This project will use [Semantic Versioning](https://semver.org/) for its tagging.

The general format:

 **MAJOR.MINOR.PATCH**, eg. `1.0.0`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward-compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install terraform CLI :floppy_disk:

### Reason for the Terraform CLI update

Update the installation process of Terraform CLI according to the latest documentation from HashiCorp.

[Install terraform CLI :computer:](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Fixed gpg deprecation issue

- Suppressed output from the wget command
- Added key fingerprint verification step
- Updated the command to add the repository to sources.list.d
- Updated workflow steps to `before` instead of `init`

## Env vars :capital_abcd:

### Persisting env vars in Gitpod

Gitpod allows to persist env vars in the workspace. This is useful for storing sensitive information like AWS credentials.

```bash
gp env PROJECT_ROOT=/workspace/terraform-beginner-bootcamp-2023
```

This will set the variable in all future Gitpod workspaces

>Any variables set in `.gitpod.yml` should not contain sensitive information. :exclamation:

## AWS CLI Installation :cloud:

Code is in the `aws-cli` task in the [.gitpod.yml](.gitpod.yml) file.

- [AWS CLI install and update instructions](https://docs.aws.amazon.com/cli/latest/userguide/-getting-started-install.html)
- [AWS security credentials](https://docs.aws.amazon.com/IAM/latest/UserGuide/security-creds.html)
- [Environment variables to configure the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

How to check if our AWS credentials are working:

```bash
aws sts get-caller-identity
```

AWS Env Vars example:

```bash
export AWS_ACCESS_KEY_ID='AKIAIOSFODNN7EXAMPLE'
export AWS_SECRET_ACCESS_KEY='xxxxxxxxxxxxxxxxxxxxxxxxxEXAMPLEKEY'
export AWS_DEFAULT_REGION='eu-central-1'
```

Example of successful output:

```json
{
    "UserId": "AKIAIOSFODNN7EXAMPLE",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/tfuser"
}
```

## Terraform Basics

### Terraform registry

The Terraform Registry is the official registry for sharing Terraform providers, modules, and other artifacts. It is hosted at [registry.terraform.io](https://registry.terraform.io).

- **Providers**: [registry.terraform.io/browse/providers](https://registry.terraform.io/browse/providers)
- **Modules**: [registry.terraform.io/browse/modules](https://registry.terraform.io/browse/modules)

### Terraform console

Invoked by typing `terraform` in the terminal.

#### `terraform init`

Used to initialize a Terraform working directory. It is the first command that should be run after writing a new Terraform configuration or cloning an existing one.

#### `terraform plan`

Used to create an execution plan. Terraform performs a refresh, unless explicitly disabled, and then determines what actions are necessary to achieve the desired state specified in the configuration files.

#### `terraform apply`

Used to apply the changes required to reach the desired state of the configuration, or the pre-determined set of actions generated by a `terraform plan` execution plan.

Use `terraform apply --auto-approve` to skip the confirmation prompt.

#### `terraform destroy`

Used to destroy the Terraform-managed infrastructure.

#### `terraform validate`

Used to validate the configuration files in a directory, referring only to the configuration and not accessing any remote services such as remote state, provider APIs, etc.

### Terraform lock file `terraform.lock.hcl`

Terraform lock files are JSON files that track the versions of modules and providers in a Terraform configuration. They are used to ensure that Terraform always installs the same versions of the modules and providers that were used during initial deployment.

### Terraform state file `terraform.tfstate`

Terraform stores the state of the managed infrastructure and configuration. This state is used by Terraform to map real-world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures.

This file **can contain sensitive data** and **should not be committed** to version control.

### Terraform directory `.terraform`

The `.terraform` directory contains plugins and other files that Terraform uses to access and manage your providers.

## Issue with Terraform Cloud login in Gitpod

`terraform login` command in Gitpod will launch a Lynx browser window to authenticate with Terraform Cloud. However, the browser window will not be able to load the page correctly.

The workaround is to manually generate a token in Terraform Cloud and use it to login.

[https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/api-tokens](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/api-tokens)

The Terraform login generates a token in the file `/home/gitpod/.terraform.d/credentials.tfrc.json`.

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "xxxREPLACExxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  }
}
```

The `TF_CLI_CONFIG_FILE` variable can be used to point to the location of the terraform token file.

### Automation of Terraform Cloud login

#### Set env vars

```bash
# Set env variables
gp env TF_CLI_CONFIG_FILE='/home/gitpod/.terraform.d/credentials.tfrc.json'
gp env TF_TOKEN='xxxREPLACExxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
```

#### Create bash script in `bin/tflogin.sh`

```bash
#!/bin/bash

if [ -z "$TF_CLI_CONFIG_FILE" ]; then
  echo "Error: TF_CLI_CONFIG_FILE environment variable is not set"
  exit 1
fi

cat <<EOF > "$TF_CLI_CONFIG_FILE"
{
  "credentials": {
    "app.terraform.io": {
      "token": "$TF_TOKEN"
    }
  }
}
EOF
```

### Setting TF_VAR to override settings in aws provider

To fix the issue with the `aws` provider not being able to find the credentials, we can set the `TF_VAR` environment variable to override the settings in the `aws` provider.

Added following variables to Gitpod env vars:

```bash
gp env TF_VAR_aws_access_key="$AWS_ACCESS_KEY_ID"
gp env TF_VAR_aws_secret_key="$AWS_SECRET_ACCESS_KEY"
```

This way, Terraform will use the `TF_VAR_aws_access_key` and `TF_VAR_aws_secret_key` environment variables to set the `aws_access_key` and `aws_secret_key` variables, respectively.

```terraform
provider "aws" {
  region = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
provider "random" {
  # Configuration options
}

variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

variable "region" {
  default = "eu-central-1"
}
```
[TOC](#table-of-contents)