resource "azuread_group" "my_group" {
  name = "Group Terraform"
}
resource "azuread_user" "test_user" {
  user_principal_name = "pau@aterraformoutlook.onmicrosoft.com"
  display_name        = "Pau Yanez"
  mail_nickname       = "pauy"
  password            = "Password.1234!"
}