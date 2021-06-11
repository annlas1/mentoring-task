terraform {
  required_providers {
    google = {
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

resource "google_compute_instance" "vm_instance" {
  name         = "kotlet-vm"
  machine_type = "f1-micro"
  tags         = ["web"]
  metadata = {
    "startup-script" = file("startup-script.txt")
  }
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

}
resource "google_compute_network" "vpc_network" {
  name = "tf-network"
}

resource "google_compute_firewall" "rules" {
  name    = "allow-tag"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  target_tags = ["web"]
}