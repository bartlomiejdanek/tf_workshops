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
