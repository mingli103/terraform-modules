module "common_tags_test" {
  source = "../../"

  app_name           = "test"
  service_name       = "test"
  environment_name   = "test"
  team_name          = "test"
  additional_tag_map = {}
}

output "common_tags_test" {
  value = module.common_tags_test.tags
}
