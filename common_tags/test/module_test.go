package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestModule(t *testing.T) {
	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "./fixture-basic",
		Vars: map[string]interface{}{
		},
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)
	
	// Get the output values and verify they match expected tags
	tags := terraform.OutputMap(t, terraformOptions, "common_tags_test")
	
	// Verify each expected tag is present and has the correct value
	assert.Equal(t, "test", tags["App"], "App tag should be 'test'")
	assert.Equal(t, "test", tags["Env"], "Env tag should be 'test'")
	assert.Equal(t, "test", tags["Service"], "Service tag should be 'test'")
	assert.Equal(t, "test", tags["Team"], "Team tag should be 'test'")
	
	// Verify we have exactly 4 tags (no extra tags)
	assert.Len(t, tags, 4, "Should have exactly 4 tags")
}
