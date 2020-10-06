resource "github_repository" "tf_modules" {
  name        = "tf_modules"
  description = "My fancy tf modules"
  visibility  = "private"
  auto_init   = true
}
