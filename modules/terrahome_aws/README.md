# Terrahome AWS

```hcl
module "home_matrix" {
  source = "./modules/terrahome_aws"
  user_uuid = var.user_uuid
  public_path = var.matrix_public_path
  content_version = var.content_version
}
```

The public firectory expect the following structure:

- index.html
- error.html
- assets

All top files in assets will be copied, except any subdirectories.
