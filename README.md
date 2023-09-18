# <span style="color:white">Terraform</span> <span style="color:green">Beginner</span> <span style="color:red">Bootcamp</span> 2023

## Semantic versioning :mage:

This project will use [Semantic Versioning](https://semver.org/) for its tagging.

The general format:

 **MAJOR.MINOR.PATCH**, eg. `1.0.0`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward-compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install terraform CLI

### Reason for the Terraform CLI update

Update the installation process of Terraform CLI according to the latest documentation from HashiCorp.

[Install terraform CLI :code:](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Fixed gpg deprecation issue

- Suppressed output from the wget command
- Added key fingerprint verification step
- Updated the command to add the repository to sources.list.d
- Updated workflow steps to `before` instead of `init`
