provider "github" {
  token = var.github_token
}
resource "github_repository" "terraform" {
  name        = "terraform"
  description = "Create a repository using Terraforms "
  auto_init   = true
//  private     = true
}
resource "github_branch" "develop" {
  depends_on = [github_repository.terraform]
  repository = "terraform"
  branch     = "develop"
}
resource "github_branch_protection" "protection" {
  repository_id = github_repository.terraform.node_id
  pattern = "main"
  enforce_admins = true
}

resource "github_user_ssh_key" "ssh_key" {
  title = "samirus"
  key   = file("id_rsa.pub")
}