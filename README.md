# <span style="color:white">Terraform</span> <span style="color:green">Beginner</span> <span style="color:red">Bootcamp</span>

## Project Structure
This project demonstrates Terraform infrastructure as code with AWS S3 bucket configurations:
- `main.tf` - Main Terraform configuration for S3 bucket creation
- `provider.tf` - AWS provider configuration for multiple regions
- `random.tf` - Random integer generation for unique naming
- `imported_bucket.tf` - Example of an imported S3 bucket configuration

## Development Environment
The project includes a devfile configuration with the following commands:
- `install` - Initializes Terraform (`terraform init`)
- `build` - Plans Terraform changes (`terraform plan`)
- `test` - Formats and validates Terraform code (`terraform fmt -check && terraform validate`)

## AWS Resources
This project creates and manages AWS S3 buckets with:
- Versioning enabled
- Server-side encryption (AES256)
- Public access blocking
- Resource tagging

## License
This project is licensed under the MIT License - see the LICENSE file for details.