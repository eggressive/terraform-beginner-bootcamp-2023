# <span style="color:white">Terraform</span> <span style="color:green">Beginner</span> <span style="color:red">Bootcamp</span> 2023

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

## Env vars

### Persisting env vars in Gitpod :capital_abcd:

Gitpod allows to persist env vars in the workspace. This is useful for storing sensitive information like AWS credentials.

```bash
gp env PROJECT_ROOT=/workspace/terraform-beginner-bootcamp-2023
```

This will set the variable in all future Gitpod workspaces

>Any variables set in `.gitpod.yml` should not contain sensitive information. :exclamation:
