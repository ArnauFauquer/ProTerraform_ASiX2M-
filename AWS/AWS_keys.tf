resource "aws_key_pair" "dev" {
  key_name   = "dev-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdQWwXLD3ZmICApI0f9bT4fpQdhvR5MiPGfMw1iscNF2E9HbfHvmzjeqZ9zRT4pIRrcsU0VK3ra9wPce8KuIbjyHdMtkD+4p9hbKf0yhRSd55HRs9sYH73W4Lkmet01W+VI7zxY2sj6a7+tBhLr/k/u0csXx0kpkXr8GVnKKub7HIs5vOWdV7kAmF5HZTFV1g4BR8ZH0S7tpeOoorVpFkdESx+k3nKIcyKACtACxkk+k1yoTfX5/4nSI6rh6zWrOcn/oOp6VfRbVnRWKZH1iTaqXLAvHxUJctCFLpUrmpJ3HPOXHdExVH4mi9EFBnfLC2UdzxwzgJ+D96dHKR64FTN aws_tranxfer_ssh_key"
}