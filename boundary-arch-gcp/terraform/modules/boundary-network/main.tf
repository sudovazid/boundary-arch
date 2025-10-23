# boundary-vpc
resource "google_compute_network" "boundary_vpc" {
  name                    = var.boundary-vpc-name
  project                 = var.project-id
  auto_create_subnetworks = false
}
# public-subnet
resource "google_compute_subnetwork" "public-subnet" {
  name                     = var.public-subnet
  network                  = google_compute_network.boundary_vpc.id
  region                   = var.region
  ip_cidr_range            = "10.1.0.0/16"
  private_ip_google_access = true
  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# private-subnet
resource "google_compute_subnetwork" "private-subnet" {
  name                     = var.private-subnet
  network                  = google_compute_network.boundary_vpc.id
  region                   = var.region
  ip_cidr_range            = "10.2.0.0/16"
  private_ip_google_access = true
  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}


