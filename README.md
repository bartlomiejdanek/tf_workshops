# Terraform kickoff

## GitHub Provider

* [Provider](https://www.terraform.io/docs/providers/github/index.html)

```
# Configure the GitHub Provider
provider "github" {
  token = var.github_token
  owner = var.github_owner
}

# Add a user to the organization
resource "github_membership" "membership_for_user_x" {
  # ...
}
```

## Project setup

```bash
$ cat terraform.tf

terraform {
  required_version = "~> 0.12"
}
```

```bash
$ cat output.tf

```

```bash
$ cat variables.tf

```

## Add GitHub provider

```terraform
$ cat github_provider.tf
provider "github" {
  # token = var.github_token
  # owner = var.github_owner
}
```

```bash
$ cat terraform.tf

terraform {
  required_version = "~> 0.12"

  required_providers {
    github = "~> 3.0.0"
  }
}
```

```bash
$ terraform init # install providers
```

```bash
$ terraform apply

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

## Data source

```bash
cat <mygithublogin>.tf
data "github_user" "me" {
  name = "<mygithublogin>"
}
```

```bash
cat output.tf
output "gh_user_me" {
  value = data.github_user.me
}

output "gh_user_me_name" {
  value = data.github_user.me.name
}
```

```bash
$ terraform apply

  ....
  ....
  ....
  ....
  ]
  "username" = "bartlomiejdanek"
}
gh_user_me_name = Bartłomiej Danek
```
## Create repository

```bash
$ cat repository.tf
resource "github_repository" "tf_modules" {
  name        = "tf_modules"
  description = "My fancy tf modules"

  visibility = "private"

  template {
    owner      = "github"
    repository = "terraform-module-template"
  }
}
```
```bash
$ terraform apply

data.github_user.me: Refreshing state...

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # github_repository.tf_modules will be created
  + resource "github_repository" "tf_modules" {
      + allow_merge_commit     = true
      + allow_rebase_merge     = true
      + allow_squash_merge     = true
      + archived               = false
      + default_branch         = (known after apply)
      + delete_branch_on_merge = false
      + description            = "My fancy tf modules"
      + etag                   = (known after apply)
      + full_name              = (known after apply)
      + git_clone_url          = (known after apply)
      + html_url               = (known after apply)
      + http_clone_url         = (known after apply)
      + id                     = (known after apply)
      + name                   = "tf_modules"
      + node_id                = (known after apply)
      + private                = (known after apply)
      + ssh_clone_url          = (known after apply)
      + svn_url                = (known after apply)
      + visibility             = "private"
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

github_repository.tf_modules: Creating...
github_repository.tf_modules: Creation complete after 6s [id=tf_modules]
```
## Branch

```bash
$ cat branch.tf
locals {
  branch_name = "dummy"
}
resource "github_branch" "dummy" {
  repository    = github_repository.tf_modules.name
  branch        = local.branch_name
  source_branch = "main"
}
```

## Repository file

```bash
$ cat file.tf
resource "github_repository_file" "gitignore" {
  repository = github_repository.tf_modules.name
  file       = ".gitignore"
  content    = "**/*.tfstate"
  branch     = local.branch_name

  depends_on = [github_branch.dummy]
}
```
## Rename repository

```bash
$ cat repository.tf

resource "github_repository" "renamed_tf_modules" {
  name        = "tf_modules"
  description = "My fancy tf modules"
  visibility  = "private"
  auto_init   = true
}
```

```bash
$ terraform apply

Error: Reference to undeclared resource

  on branch.tf line 6, in resource "github_branch" "dummy":
   6:   repository    = github_repository.tf_modules.name

A managed resource "github_repository" "tf_modules" has not been declared in
the root module.
```
```bash
$ terraform apply

Error: Reference to undeclared resource

  on file.tf line 2, in resource "github_repository_file" "gitignore":
   2:   repository = github_repository.tf_modules.name

A managed resource "github_repository" "tf_modules" has not been declared in
the root module.
```

```bash
$ terraform apply

data.github_user.me: Refreshing state...
github_repository.tf_modules: Refreshing state... [id=tf_modules]
github_branch.dummy: Refreshing state... [id=tf_modules:dummy]
github_repository_file.gitignore: Refreshing state... [id=tf_modules/.gitignore]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
  - destroy

Terraform will perform the following actions:

  # github_repository.renamed_tf_modules will be created
  + resource "github_repository" "renamed_tf_modules" {
      + allow_merge_commit     = true
      + allow_rebase_merge     = true
      + allow_squash_merge     = true
      + archived               = false
      + auto_init              = true
      + default_branch         = (known after apply)
      + delete_branch_on_merge = false
      + description            = "My fancy tf modules"
      + etag                   = (known after apply)
      + full_name              = (known after apply)
      + git_clone_url          = (known after apply)
      + html_url               = (known after apply)
      + http_clone_url         = (known after apply)
      + id                     = (known after apply)
      + name                   = "tf_modules"
      + node_id                = (known after apply)
      + private                = (known after apply)
      + ssh_clone_url          = (known after apply)
      + svn_url                = (known after apply)
      + visibility             = "private"
    }

  # github_repository.tf_modules will be destroyed
  - resource "github_repository" "tf_modules" {
      - allow_merge_commit     = true -> null
      - allow_rebase_merge     = true -> null
      - allow_squash_merge     = true -> null
      - archived               = false -> null
      - auto_init              = true -> null
      - default_branch         = "main" -> null
      - delete_branch_on_merge = false -> null
      - description            = "My fancy tf modules" -> null
      - etag                   = "W/\"fecdf22320334ac410fca98b81304e3688aabb435482a68e240301aa4bd03562\"" -> null
      - full_name              = "bartlomiejdanek/tf_modules" -> null
      - git_clone_url          = "git://github.com/bartlomiejdanek/tf_modules.git" -> null
      - has_downloads          = false -> null
      - has_issues             = false -> null
      - has_projects           = false -> null
      - has_wiki               = false -> null
      - html_url               = "https://github.com/bartlomiejdanek/tf_modules" -> null
      - http_clone_url         = "https://github.com/bartlomiejdanek/tf_modules.git" -> null
      - id                     = "tf_modules" -> null
      - is_template            = false -> null
      - name                   = "tf_modules" -> null
      - node_id                = "MDEwOlJlcG9zaXRvcnkzMDE3NDQ1NDA=" -> null
      - private                = true -> null
      - ssh_clone_url          = "git@github.com:bartlomiejdanek/tf_modules.git" -> null
      - svn_url                = "https://github.com/bartlomiejdanek/tf_modules" -> null
      - topics                 = [] -> null
      - visibility             = "private" -> null
    }

Plan: 1 to add, 0 to change, 1 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```
