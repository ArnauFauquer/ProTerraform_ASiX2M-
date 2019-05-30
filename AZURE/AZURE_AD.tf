resource "azuread_group" "my_group" {
 name = "Group Terraform Video"
}

resource "azuread_user" "Arnau" {
 user_principal_name = "arnaubague@aterraformoutlook.onmicrosoft.com"
 display_name        = "Arnau Bagué"
 mail_nickname       = "arnauy"
 password            = "${var.PasswordMV}"
}
