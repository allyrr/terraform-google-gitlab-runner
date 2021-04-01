
resource "google_compute_firewall" "allow-internal-workers-ssh" {
  name = "${google_compute_network.main.name}-allow-internal-workers-ssh"
  network = google_compute_network.main.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = [google_compute_subnetwork.main_subnet_0.ip_cidr_range]
  target_tags = [var.gcp_gitlab_resource_prefix]
  description = "Allow ssh access inside VPC for all spinned up workers. Managed by terrafrom"
}

resource "google_compute_firewall" "allow-manager-ssh" {
  name = "${google_compute_network.main.name}-allow-manager-ssh"
  network = google_compute_network.main.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = [var.gcp_gitlab_resource_prefix]
  description = "Allow ssh access from world to GitLab manager. Managed by terrafrom"
}


resource "google_compute_firewall" "allow-all-internal" {
  name = "docker-machines"
  network = google_compute_network.main.name
  allow {
    protocol = "tcp"
    ports    = ["2376"]
  }
  source_ranges = [google_compute_subnetwork.main_subnet_0.ip_cidr_range]
  target_tags = ["docker-machine"]
  description = "Allow encrypted communication with the docker daemon to all VMs with docker-machine tag. Managed by terrafrom"
}
