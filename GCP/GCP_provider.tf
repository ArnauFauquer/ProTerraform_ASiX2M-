provider "google" {
  credentials = "${file("~/Terraform-3ebf4f5f710f.json")}"
  #credentials = "${file("Terraform-159604c0f4c0.json")}"
  project     = "terraform-240809"
  region      = "${var.GPC_main_region}}"
}

variable "GPC_main_region" {
  type = "string"
  default = "europe-west1-b"
}

variable "public_key_path" {
  description = "Path to file containing public key"
  default     = "~/gcp.pub"
}

variable "private_key_path" {
  description = "Path to file containing private key"
  default     = "~/gcp.priv"
}