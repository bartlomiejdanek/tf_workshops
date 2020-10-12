---
theme : "simple"
highlightTheme: "github"
title: Terraform
---

# Terraform

---

## Terraform

* Build/manage any cloud, infrastructure or service
* Code is written in HCL
* Does not enforce a file/directory structure
* Build steps are expressed as code (dependencies between resources)
* DRY aka modules
* Immutable infrastructure\*
* CLI tool
* API wrapper for other API's (AWS, Kubernetes, GCP etc.)

---

## Concept

```
<resource-type> <resource-klass> <resource-instance> {
  ...
  ...
  ...
}
```

---

## Data resource

```
data "github_branch" "uat" {
  repository = "example"
  branch     = "uat"
}
```

---

## Resource

```
resource "github_branch" "development" {
  repository = "example"
  branch     = "development"
}
```

---

## Output

```
output "development_source_sha" {
  value = "${github_branch.development.source_sha}:-:${data.github_branch.uat.sha}"
}
```

---

## CLI

```
terraform init            # initialize current directory
terraform plan            # dry run to see changes
terraform apply           # apply changes
terraform refresh         # refresh the state file
terraform output          # view Terraform outputs
terraform destroy         # destroy what was built by Terraform
terraform console         # interactive Terraform session
terraform state           # play with the state file, but carefully
terraform show            # show the state file
terraform validate        # validates all Terraform's files
terraform -help           # help for Terraform
terraform <command> -help # help for a Terrform's command
```

---

## Terraform state

Terraform keeps information about resources it has built in a state file. The file contains all needed data that Terraform needs to modify a resource.
By default Terraform uses local storage to store the state file.

---

### Terraform state

Local:
* sometimes includes sensitive data
* hard to share the file with other people (dropbox?)
* backups responsibilities delegated to a user

---

### Terraform state

Remote:
* support multiple backends (S3, GCS, Terraform Cloud, PostgreSQL, Consul, HTTP ... and so on)
* easy to share
* backups responsibilities delegated to a backend

---

### State locking

* has to be supported by a backend
* enables **only** when an operation needs to write state
* prevents against corrupting a state file
* lock can be skipped by passing `-lock` flag, eg. `terraform apply -lock`
* **avoid Ctrl/Cmd-C** (**once**)

---

### Terraform Cloud

* [https://app.terraform.io](https://app.terraform.io)
* it's easy to use (requires just a token)
* stores states file
* stores **cloud/service credentials**
* stores **terraform variables**
* queued remote (auto)apply triggered by VCS integration
* **2FA**

---

## Terraform versions

* current stable 0.13.4
* currently most popular 0.12.XY (@selleo)
* installation
  * [asdf](https://github.com/Banno/asdf-hashicorp)
  * [terraform.io](https://www.terraform.io/downloads.html)

---

```bash
asdf plugin-add terraform
asdf install terraform 0.12.29
asdf local terraform 0.12.29
```

---

## Terraform variables / expressions

Variables definitions should be stored `*.tfvars` files.

* primitive
  * string
  * number
  * bool

---

## Terraform variables / expressions

* structural
  * list(\<TYPE\>)
  * map(\<TYPE\>)
  * object({\<ATTR NAME\> = type, ...})
  * tuple(\<TYPE\>) (*collection which is ordered*)
* *null*

> [source](https://www.terraform.io/docs/configuration/variables.html#type-constraints)

---

## String

```
variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
}
```

---

## Number

```
variable "port" {
  type        = number
  description = "Default HTTP port"
}
```

---

## Boolean

```
variable "enabled" {
  type        = bool
  description = "HTTP traffic enabled"
  default     = false
}
```

---

## List

```
variable "availability_zone_names" {
  type    = list(string)
  default = ["us-west-1a", "eu-north-1a"]
}
```

---

## Map

```
variable "size" {
  type = map
  default = {
    "small"  = "t3.small"
    "medium" = "t3.medium"
    "big"    = "t3.large"
  }
}

# plan = var.size["small"]
```

---

## Object

```
variable "nomad_ports" {
  type = list(object({
    internal = number
    external = number
    protocol = string
  }))
  default = [
    {
      internal = 4646
      external = 4646
      protocol = "tcp"
    }
  ]
}
```

---

## Tuple

```
variable "rack_env" {
  type = tuple([string, bool, number])
}

# rack_env = ["RACK_ENV", true, 3000]
```

---

### Environment Variables

By default Terraform searches the environment of its own process for env. variables named with prefix `TF_VAR_`.

```
TF_VAR_enabled=true terraform apply
```

---

### Output Variables

Outputs allows to define values in the configuration that is being shared with users or resources.
Outputs are also printed out after such actions like `apply`, `refresh` or `destroy`.

---

## Sample output

```
resource "github_branch" "development" {
  repository = "example"
  branch     = "development"
}

output "development_source_sha" {
  value = github_branch.development.source_sha
}
```

---

## Terraform Functions

Terraform has a number of built-in functions for numeric, string, collection, encoding, date, time, encoding, filesystem, hash, IP networks or type conversion.

[source](https://www.terraform.io/docs/configuration/functions.html)

---

## Local Values

It assigns a name to an expression. It can be treated as a temporary variable the same way like it's done in programming languages.

---

## Terraform fuctions

```
variable "regions" { type = list }
variable "aws_global_regions" { type = list }

regions = list["north-1", "central-1"]
aws_global_regions = ["eu", "na"]

locals {
  regions = setproduct(var.regions, var.aws_global_regions)
}

output "regions" {
  value = local.regions
}
```

---

## `setproduct` output

```
regions = [[
    "north-1",
    "eu",
  ],[
    "north-1",
    "na",
  ],[
    "central-1",
    "eu",
  ],[
    "central-1",
    "na",
  ],
]
```

---

## Meta arguments

These arguments might useful to define resource dependencies, change a default provider or create multiple resource instances.

* `depends_on` - list of dependencies for a resource
* `count` - number of identical resources to create
* `for_each`, to create multiple instances according to a map, or set of strings

---

## Meta arguments

* `provider`, for selecting a non-default provider configuration
* `lifecycle`, for lifecycle customizations
  * `create_before_destroy` - ensure that a new instance is created before the old one is destroye
  * `prevent_destroy` - a deletion police man
  * `ignore_changes` - listed attributes will not be taken into state verification

---

## `count` example

```
resource "random_id" "bucket_id" {
  byte_length = 2
  count = 3
}

resource "random_id" "nope" {
  byte_length = 4
  count = 0
}
```

[source](https://www.terraform.io/docs/configuration/resources.html#meta-arguments)

---

## Conditional logic

```
locals { foo = true }

output "bar" { value = (local.foo ? list("baz") : list()) }

variable "userdata_path" {
  default = ""
}

data "userdata_file" "template" {
  vars = {
    file_contents = (length(var.userdata_path) > 0 ? \
      file(var.userdata_path) : "")
  }
}
```

---

## Modules

A module is a container for multiple resources that are used together. Every Terraform configuration has at least one module, known as its root module, which consists of the resources defined in the .tf files in the main working directory.

---

### Structure

Modules use:
* input variables
* output values
* resources

---

```bash
$ tree modules/sample-module/
.
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
```

---

```bash
$ cat sample.tf

module "sample_usage" {
  source = "./modules/sample-module"

  name = local.name
  tags = local.tags
}
```

```
$ cat sample.tf

module "sample_usage_remote" {
  source = "github.com/selleo/tf-modules//modules/sample-module?ref=v0.8.9"

  name = local.name
  tags = local.tags
}
```

---

## Good practicies

* **avoid multiple Ctrl/Cmd-C key strokes** during terraforming
* avoid `null_resources`
* use auto format (`terraform fmt -help`)

---

## Good practicies

* naming resources
  * use `_` over `-`
  * Good: `resource "aws_route_table" "public" {}`
  * Bad: `resource "aws_route_table" "public-route_table" {}`
  * Bad: `resource "aws_route_table" "public-aws_route-table" {}`
  * Always use singular nouns for names

---

## Good practicies

* specify exact version for providers/modules, eg. `~> 2.59.13`
* use encrypted remote backend
* prefer HCL over JSON (use `jsonencode`)
* use newest stable version (continuous upgrades)

---

## Online examples

---

### tf 0.12

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

---

### tf 0.11

```
# Configure the GitHub Provider
provider "github" {
  token = "${var.github_token}"
  owner = "${var.github_owner}"
}

# Add a user to the organization
resource "github_membership" "membership_for_user_x" {
  # ...
}
```

---

https://github.com/bartlomiejdanek/tf_workshops/tree/master

