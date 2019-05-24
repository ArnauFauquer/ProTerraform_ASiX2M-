resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  zone = "${var.GPC_main_region}"

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20190514::wq
      "

    }
  }
  metadata_startup_script = "sudo apt install docker -y; sudo apt install docker-compose -y"

  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config = {
    }
  }
}
