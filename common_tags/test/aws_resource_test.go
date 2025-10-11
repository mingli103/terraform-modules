package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestModuleWithAWSResources(t *testing.T) {
	// This test requires LocalStack to be running
	// Run: docker-compose up -d localstack
	
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixture",
		Vars: map[string]interface{}{
			// No vars needed - using defaults
		},
		// Override the default terraform options to use the aws-resource-test.tf file
		TerraformBinary: "terraform",
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)
	
	// Get the output values and verify they match expected tags
	tags := terraform.OutputMap(t, terraformOptions, "applied_tags")
	
	// Verify each expected tag is present and has the correct value
	assert.Equal(t, "test-app", tags["App"], "App tag should be 'test-app'")
	assert.Equal(t, "test", tags["Env"], "Env tag should be 'test'")
	assert.Equal(t, "test-service", tags["Service"], "Service tag should be 'test-service'")
	assert.Equal(t, "platform", tags["Team"], "Team tag should be 'platform'")
	assert.Equal(t, "engineering", tags["CostCenter"], "CostCenter tag should be 'engineering'")
	assert.Equal(t, "terraform-modules", tags["Project"], "Project tag should be 'terraform-modules'")
	
	// Verify we have exactly 6 tags (4 standard + 2 additional)
	assert.Len(t, tags, 6, "Should have exactly 6 tags")
	
	// Verify AWS resources were created successfully
	bucketName := terraform.Output(t, terraformOptions, "bucket_name")
	assert.NotEmpty(t, bucketName, "Bucket name should not be empty")
	assert.Contains(t, bucketName, "test-bucket-", "Bucket name should contain 'test-bucket-'")
	
	topicName := terraform.Output(t, terraformOptions, "topic_name")
	assert.NotEmpty(t, topicName, "Topic name should not be empty")
	assert.Contains(t, topicName, "test-topic-", "Topic name should contain 'test-topic-'")
}
