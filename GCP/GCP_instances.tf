resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  zone = "${var.GPC_main_region}"

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20190514"

    }
  }
 # metadata_startup_script = "sudo apt install docker -y; sudo apt install docker-compose -y"

  network_interface {
    network       = "${google_compute_network.vpc_network.name}"
    access_config = {
    }
  }
}

resource "google_compute_instance" "docker" {
  count = 1
  name         = "tf-docker-${count.index}"
  machine_type = "f1-micro"
  zone         = "${var.GPC_main_region}"
  tags         = ["docker-node"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20190514"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Ephemeral
    }
  }
  provisioner "file" {
    destination = "dcker-compose.yaml"
  }
  provisioner "remote-exec" {
    connection {
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
      "sudo docker-compose up"
    ]
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/compute.readonly"]
  }
  metadata {
    ssh-keys = "root:${file("${var.public_key_path}")}"
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