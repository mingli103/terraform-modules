# Testing Guide

This repository includes comprehensive testing setup for Terraform modules using both basic testing and LocalStack for AWS resource testing.

## Quick Start

### Basic Testing (No AWS Resources)

```bash
cd common_tags/test
go test -v
```

### LocalStack Testing (With AWS Resources)

```bash
# Start LocalStack
docker-compose up -d localstack

# Run tests
cd common_tags/test
go test -v

# Stop LocalStack
docker-compose down
```

### Using the Test Script

```bash
# Automated LocalStack testing
./scripts/test-with-localstack.sh
```

## Test Types

### 1. Basic Module Tests (`TestModule`)

- Tests pure Terraform logic (no AWS resources)
- Fast execution (~1 second)
- No external dependencies

### 2. AWS Resource Tests (`TestModuleWithAWSResources`)

- Tests modules that create actual AWS resources
- Uses LocalStack for mocking AWS services
- Slower execution (~10-30 seconds)
- Requires Docker and LocalStack

## LocalStack Setup

### Services Available

- S3, DynamoDB, Lambda, IAM, STS
- CloudFormation, API Gateway, CloudWatch
- SNS, SQS, SSM, Step Functions, EC2
- And many more...

### Configuration

- **Port**: `localhost:4566`
- **Region**: `us-east-1`
- **Credentials**: Dummy values (no real AWS needed)

## CI/CD Integration

The GitHub Actions workflow automatically:

1. Starts LocalStack container
2. Runs both basic and AWS resource tests
3. Cleans up containers
4. Tags releases on success

## Example Test Structure

```go
func TestModuleWithAWSResources(t *testing.T) {
    terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
        TerraformDir: "./fixture",
    })
    
    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)
    
    // Verify outputs and resources
    tags := terraform.OutputMap(t, terraformOptions, "applied_tags")
    assert.Equal(t, "expected-value", tags["Key"])
}
```

## Troubleshooting

### LocalStack Not Starting

```bash
# Check if port 4566 is available
lsof -i :4566

# Check LocalStack logs
docker-compose logs localstack
```

### Tests Failing

```bash
# Run with verbose output
go test -v -timeout 60m

# Check Terraform logs
cd common_tags/test/fixture
terraform init
terraform plan
```

## Best Practices

1. **Use basic tests** for pure logic modules
2. **Use LocalStack tests** for modules with AWS resources
3. **Always clean up** resources in tests
4. **Use meaningful assertions** with descriptive messages
5. **Set appropriate timeouts** for complex tests
