# Example AWS resource test using LocalStack
# This demonstrates how to test modules that create actual AWS resources

module "common_tags_test_with_resources" {
  source = "../../"

  app_name           = "test-app"
  service_name       = "test-service"
  environment_name   = "test"
  team_name          = "platform"
  additional_tag_map = {
    "CostCenter" = "engineering"
    "Project"    = "terraform-modules"
  }
}

# Example S3 bucket using the tags
resource "aws_s3_bucket" "test_bucket" {
  bucket = "test-bucket-${random_string.bucket_suffix.result}"
  tags   = module.common_tags_test_with_resources.tags
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Example SNS topic using the tags (simpler than DynamoDB)
resource "aws_sns_topic" "test_topic" {
  name = "test-topic-${random_string.topic_suffix.result}"
  tags = module.common_tags_test_with_resources.tags
}

resource "random_string" "topic_suffix" {
  length  = 8
  special = false
  upper   = false
}

output "bucket_name" {
  value = aws_s3_bucket.test_bucket.bucket
}

output "topic_name" {
  value = aws_sns_topic.test_topic.name
}

output "applied_tags" {
  value = module.common_tags_test_with_resources.tags
}
