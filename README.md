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
export AWS_SECRET_ACCESS_KEY='wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
export AWS_DEFAULT_REGION='eu-central-1'
```

Example of successful output:

```json
{
    "UserId": "AIDA4BN7ZFFNOOAGYY2YB",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/tfuser"
}
```
