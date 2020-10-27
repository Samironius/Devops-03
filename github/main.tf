provider "github" {
  token = var.github_token
}

resource "github_repository" "example" {
  name        = "example"
  description = "My awesome codebase"
}

data "github_branch" "development" {
  repository = "example"
  branch     = "development"
}