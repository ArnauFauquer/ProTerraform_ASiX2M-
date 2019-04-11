provider "google" {
  credentials = "${file("~/My First Project-c3697c044f8b.json")}"
  project     = "arched-symbol-231409"
  region      = "eu-west-1"
}
