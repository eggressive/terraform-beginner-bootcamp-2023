# Terraform Beginner Bootcamp 2023 - Week 1 :school_satchel:

## Root Module Structure

Root module structure:

- 📁 `PROJECT_ROOT`
   - 📄 `main.tf` - everything else
   - 📄 `variables.tf` - input variables
   - 📄 `terraform.tfvars` - the data of variables we want to load in our terraform project
   - 📄 `providers.tf` - required providers + configuration
   - 📄 `outputs.tf` - stores outputs
   - 📄 `README.md` - required for root modules

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

### Terraform Cloud Variables

You can create both environment variables and Terraform variables in Terraform Cloud.

- Environment variables are stored in plain text and are not encrypted.
- Terraform variables are stored encrypted and are only available to Terraform Cloud runs. Locally set in `terraform.tfvars` file.

Terraform often needs cloud provider credentials and other sensitive information that should not be widely available within your organization. To protect these secrets, you can mark any Terraform or environment variable as sensitive data by clicking its Sensitive checkbox that is visible during editing.

### Loading Terraform Input Variables

[Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)


**Input variables are like function arguments.**

Input variables let you customize aspects of Terraform modules without altering the module's own source code. This functionality allows you to share modules across different Terraform configurations, making your module composable and reusable.

#### -var file flag

To specify individual variables on the command line, use the -var option when running the `terraform plan` and `terraform apply` commands

```hcl
terraform apply -var="image_id=ami-abc123"
```

#### terraform.tfvars file

To set lots of variables, it is more convenient to specify their values in a variable definitions file (with a filename ending in either .tfvars or .tfvars.json).

#### auto.tfvars file

Terraform also automatically loads a number of variable definitions files if they are present. Any files with names ending in `.auto.tfvars` or `.auto.tfvars.json` are loaded automatically, in alphabetical order. Files loaded this way are used to populate (but not override) variables defined using the -var option or in a terraform.tfvars file.

#### Order of Precedence

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

- Environment variables
- The terraform.tfvars file, if present.
- The terraform.tfvars.json file, if present.
- Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
- Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)
- Default values for the variables, as defined in the root module.

## Deal with Configuration Drift

### Fix missing resource with `terraform import`

[Detecting and Managing Drift with Terraform](https://www.hashicorp.com/blog/detecting-and-managing-drift-with-terraform)

### Terraform Import

[Terraform `import` command](https://developer.hashicorp.com/terraform/cli/commands/import)

## What if we lose our state file?

[Terraform State Restoration Overview](https://support.hashicorp.com/hc/en-us/articles/4403065345555-Terraform-State-Restoration-Overview)

## Fix using `terraform refresh`

```hcl
terraform apply -refresh-only --auto-approve
```

The `-refresh-only` flag tells Terraform to only refresh the state of the resources, without applying any changes. This is useful when you want to check if there are any differences between the current state of the resources and the state file, without actually making any changes to the infrastructure.

`terraform apply -refresh-only` command does not modify the infrastructure, it only updates the state file.

## Terraform Modules

### Terrafom Module structure

It is recommended to place modules in a separate directory, such as `modules`, rather than in the root module directory.

### Passing input variables to modules

Variables must ve decalred in the module's `variables.tf` file.

```hcl
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  *user_uuid = var.user_uuid*
  bucket_name = var.bucket_name
}
```

### Module Sources

[Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

The source argument in a module block tells Terraform where to find the source code for the desired child module.

```hcl
module "terrahouse_aws" {
  *source = "./modules/terrahouse_aws"*
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

#### Beware of trusting LLMs with coding assistance :heavy_exclamation_mark:

## Working with files in Terraform

### Fileexists Function

[Fileexists Function](https://www.terraform.io/docs/language/functions/fileexists.html)

### Filemd5 Function

[Filemd5 Function](https://www.terraform.io/docs/language/functions/filemd5.html)


### Path Variable

[Filesystem and Workspace Info](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

- `path.module` is the filesystem path of the module where the expression is placed. We do not recommend using path.module in write operations because it can produce different behavior depending on whether you use remote or local module sources. Multiple invocations of local modules use the same source directory, overwriting the data in path.module during each call. This can lead to race conditions and unexpected results.
- `path.root` is the filesystem path of the root module of the configuration.
- `path.cwd` is the filesystem path of the original working directory from where you ran Terraform before applying any -chdir argument. This path is an absolute path that includes details about the filesystem structure. It is also useful in some advanced cases where Terraform is run from a directory other than the root module directory. **We recommend using path.root or path.module over path.cwd where possible.**

## CDN

### Cloudfront Distribution

[S3 Origin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#s3-origin)

### Origin Access Control

[aws_cloudfront_origin_access_control](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control)

### S3 Bucket Policy

[Resource: aws_s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy)

## Terraform Locals

[Local Values](https://www.terraform.io/docs/language/values/locals.html)

[Simplify Terraform configuration with locals](https://developer.hashicorp.com/terraform/language/values/locals)

```hcl
locals {
  name_suffix = "${var.resource_tags["project"]}-${var.resource_tags["environment"]}"
}
```

### Terraform Data Sources

This allows us to source data from outside of our Terraform configuration (eg. cloud resources).

Useful when we want to reference data that is not stored in our Terraform state without importing it.

```hcl
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

[Data Sources](https://www.terraform.io/docs/language/data-sources/index.html)

## Working with JSON

### JSONencode Function

[JSONencode Function](https://www.terraform.io/docs/language/functions/jsonencode.html)
