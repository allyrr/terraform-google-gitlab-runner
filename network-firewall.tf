
resource "google_compute_firewall" "allow-ssh" {
  name = "${google_compute_network.main.name}-allow-internal-workers-ssh"
  network = google_compute_network.main.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = [google_compute_subnetwork.main_subnet_0.ip_cidr_range, "35.235.240.0/20"]
  target_tags = [var.gcp_gitlab_resource_prefix]
  description = "Allow ssh access inside VPC for all spinned up workers and + IAP for TCP forwarding. Managed by terrafrom"
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
