resource "github_repository" "renamed_tf_modules" {
  name        = "tf_modules"
  description = "My fancy tf modules"
  visibility  = "private"
  auto_init   = true
}
