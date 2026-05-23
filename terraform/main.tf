terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "project-0e2f40b3-ec23-43ff-8a7"
  region  = "us-central1"
  zone    = "us-central1-a"
}

# -------------------------
# VPC
# -------------------------

resource "google_compute_network" "vpc" {
  name                    = "devops-vpc"
  auto_create_subnetworks = false
}

# -------------------------
# SUBNET
# -------------------------

resource "google_compute_subnetwork" "subnet" {
  name          = "private-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
}

# -------------------------
# FIREWALL
# -------------------------

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-api" {
  name    = "allow-api"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["9000"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "internal-only" {
  name    = "internal-only"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["8000"]
  }

  source_ranges = ["10.0.1.0/24"]
}

# -------------------------
# API VM
# -------------------------

resource "google_compute_instance" "api_vm" {
  name         = "api-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {
    }
  }

  tags = ["api-server"]
}

# -------------------------
# INFERENCE VM
# -------------------------

resource "google_compute_instance" "inference_vm" {
  name         = "inference-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id

  }

  tags = ["inference-server"]
}
