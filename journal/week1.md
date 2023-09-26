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


To specify individual variables on the command line, use the -var option when running the `terraform plan` and `terraform apply` commands

```hcl
terraform apply -var="image_id=ami-abc123"
```

#### terraform.tfvars file

To set lots of variables, it is more convenient to specify their values in a variable definitions file (with a filename ending in either .tfvars or .tfvars.json).

#### auto.tfvars file

