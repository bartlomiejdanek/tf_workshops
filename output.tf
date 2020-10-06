output "gh_user_me" {
  value = data.github_user.me
}

output "gh_user_me_name" {
  value = data.github_user.me.name
}
