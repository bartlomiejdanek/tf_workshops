locals {
  branch_name = "dummy"
}

resource "github_branch" "dummy" {
  repository    = github_repository.renamed_tf_modules.name
  branch        = local.branch_name
  source_branch = "main"
}
