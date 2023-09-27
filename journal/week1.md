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
