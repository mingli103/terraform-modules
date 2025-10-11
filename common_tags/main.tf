locals {
  tags = merge(
    var.additional_tag_map,
    {
      "App"             = var.app_name
      "Service"         = var.service_name
      "Env"             = var.environment_name
      "Team"            = var.team_name
    }
  )
}
