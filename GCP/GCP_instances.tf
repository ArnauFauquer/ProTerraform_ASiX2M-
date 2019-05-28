resource "google_compute_instance" "docker" {
  count = 1
  name         = "tf-docker-${count.index}"
  machine_type = "g1-small"
  zone         = "${var.GPC_main_region}"
  tags         = ["docker-node"]
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20190514"
    }
  }

  network_interface {
    #network = "${google_compute_network.vpc_network.name}}"
    subnetwork = "${google_compute_subnetwork.public.name}"
    access_config {}
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/compute.readonly"]
  }

  metadata = {
    sshKeys = "root:${file("${var.public_key_path}")}"
  }

  provisioner "file" {
    connection {
      host = "${self.can_ip_forward}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
    source = "docker-compose.yaml"
    destination = "~/docker-compose.yaml"
  }

  provisioner "remote-exec" {
    connection {
      host = "${self.can_ip_forward}}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }

    inline = [
      "sudo apt update -y",
      "sudo curl -sSL https://get.docker.com/ | sh",
      "sudo usermod -aG docker `echo $USER`",
      "sudo apt install docker-compose -y",
      "sudo docker-compose up -d"
    ]
  }

}

resource "google_compute_firewall" "default" {
  name    = "tf-www-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["docker-node"]
}


