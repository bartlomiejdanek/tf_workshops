resource "github_repository_file" "gitignore" {
  repository = github_repository.renamed_tf_modules.name
  file       = ".gitignore"
  content    = "**/*.tfstate"
  branch     = local.branch_name

  depends_on = [github_branch.dummy]
}
