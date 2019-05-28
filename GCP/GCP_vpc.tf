resource "google_compute_network" "vpc_network" {
  name = "terraform"
  auto_create_subnetworks = false

}

resource "google_compute_subnetwork" "public" {
  ip_cidr_range = "192.168.0.0/24"
  name = "pub"
  region = "europe-west1"
  network = "${google_compute_network.vpc_network.name}}"
}


resource "google_compute_address" "subnet-public-address" {
  name         = "subnet-public-addreses"
  address_type = "INTERNAL"
}