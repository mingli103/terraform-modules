# Terraform Modules

Reusable Terraform modules for AWS infrastructure with comprehensive testing.

## Modules

### common_tags

Standardized tagging module for AWS resources.

**Usage:**

```hcl
module "tags" {
  source = "./common_tags"
  
  app_name         = "my-app"
  service_name     = "api"
  environment_name = "prod"
  team_name        = "platform"
  
  additional_tag_map = {
    "CostCenter" = "engineering"
  }
}
```

**Outputs:**

- `tags` - Merged tag map ready for AWS resources

## Testing

```bash
# Basic tests (no AWS)
cd common_tags/test && go test -v

# Full tests with LocalStack
./scripts/test-with-localstack.sh
```

See [TESTING.md](TESTING.md) for detailed testing guide.

## Requirements

- Terraform >= 1.0
- Go >= 1.19 (for testing)
- Docker (for LocalStack testing)
