provider "google" {
  #redentials = "${file("~/Tranxfer-8a3c7661b864.json")}"
  credentials = "${file("Terraform-159604c0f4c0.json")}"
  project     = "terraform-240809"
  region      = "${var.GPC_main_region}}"
}

variable "GPC_main_region" {
  type = "string"
  default = "europe-west1-b"
}

