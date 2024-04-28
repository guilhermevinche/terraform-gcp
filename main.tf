# configura o provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

# configura os dados do provider = GCP
provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
}

# cria a VPC - Network
resource "google_compute_network" "network-aula" {
  name = "network-aula"
}

# cria IP público
resource "google_compute_address" "ip-aula" {
  name = "ip-aula"
}

# cria Firewall e libera acesso SSH e HTTP
resource "google_compute_firewall" "firewall-aula" {
  name          = "firewall-aula"
  network       = google_compute_network.network-aula.name
  target_tags   = ["permite-ssh-http"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
}

# cria a VM
resource "google_compute_instance" "vm-aula" {
  name         = "vm-aula"
  machine_type = "f1-micro"
  tags         = ["permite-ssh-http"]

# chave ssh
  metadata = {
    ssh-keys = "ubuntu:${file("id_rsa.pub")}"
  }

# imagem do SO
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  # Associa a VM a VPC criada
  network_interface {
    network = google_compute_network.network-aula.name

    access_config {
      nat_ip = google_compute_address.ip-aula.address
    }
  }
}

# Atualiza o repositório e instala o nginx
resource "null_resource" "install_apache" {
  connection {
    type        = "ssh"
    user        = var.user
    private_key = file("id_rsa")
    host        = google_compute_address.ip-aula.address
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install nginx -y"
    ]
  }
}
