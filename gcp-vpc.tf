# create VPC
resource "google_compute_network" "main" {
  name                    = var.gcp_gitlab_resource_prefix
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}
# create subnet
resource "google_compute_subnetwork" "main_subnet_0" {
  name                     = "${google_compute_network.main.name}-subnet-0"
  private_ip_google_access = true
  ip_cidr_range            = var.gcp_main_vpc_sub_ip_range
  network = google_compute_network.main.name
  region  = var.gcp_region
}

resource "google_compute_router" "main" {
  name    = "${google_compute_network.main.name}-router-0"
  network = google_compute_network.main.name
}

# Allow static IP address for the GitLab-manager VM
resource "google_compute_address" "static" {
  name         = "${var.gcp_gitlab_resource_prefix}-manager-vm"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}

resource "google_compute_address" "main" {
  provider     = google-beta
  name         = "${google_compute_router.main.name}-ip-0"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
  labels       = { managed_by = "terraform" }
}

resource "google_compute_router_nat" "main" {
  name                               = "${google_compute_router.main.name}-nat-0"
  router                             = google_compute_router.main.name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ips                            = [google_compute_address.main.self_link]
  log_config {
    enable = false
    filter = "ALL"
  }
}

