# Allow internal traffic in the VPC (restrict ports where needed)

resource "google_compute_firewall" "boudary-controller-to-all" {
  name     = "${var.boundary-vpc-name}-internal"
  network  = google_compute_network.boundary_vpc.id
  priority = 900
  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["1-65535"]
  }
  allow {
    protocol = "icmp"
  }
  source_tags = ["management"]
  description = "Allow management subnet (controllers/consul) to reach all resources"
}

#  ALLOW controllers to workers
resource "google_compute_firewall" "allow-controller-to-worker" {
  name    = "${var.boundary-vpc-name}-allow-controller-to-worker"
  network = google_compute_network.boundary_vpc.id
  allow {
    protocol = "tcp"
    ports    = ["22", "9202"]
  }
  source_tags = ["boundary-controller"]
  target_tags = ["boundary-worker"]
}

#  ALLOW consul server communication
resource "google_compute_firewall" "allow-consul" {
  name    = "${var.boundary-vpc-name}-allow-consul"
  network = google_compute_network.boundary_vpc.id
  allow {
    protocol = "tcp"
    ports    = ["8300", "8301", "8302", "8500", "8600"]
  }
  allow {
    protocol = "udp"
    ports    = ["8301", "8302", "8600"]
  }
  source_tags = ["consul-server", "boundary-controller"]
  target_tags = ["consul-server"]

  description = "Allow Consul cluster and controller communication"
}

# Allow IAP to Boundary Workers
resource "google_compute_firewall" "allow-iap-to-boundary-workers" {
  name    = "${var.boundary-vpc-name}-allow-iap-to-boundary-workers"
  network = google_compute_network.boundary_vpc.id
  allow {
    protocol = "tcp"
    ports    = ["22", "9202"]
  }
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["boundary-worker"]
  description   = "Allow IAP access to all Boundary workers for administrative purposes"
}

#Allow boundary worker to vm's
resource "google_compute_firewall" "allow-worker-to-vm" {
  name    = "${var.boundary-vpc-name}-allow-worker-to-vm"
  network = google_compute_network.boundary_vpc.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_tags = ["boundary-worker"]
  target_tags = ["dev-vm"]

  description = "Allow boundary workers to SSH to VMs only"
}

#Allow Loadbalancer health checks
resource "google_compute_firewall" "allow-lb-health-checks" {
  name    = "${var.boundary-vpc-name}-allow-lb-health-checks"
  network = google_compute_network.boundary_vpc.id
  allow {
    protocol = "tcp"
    ports    = ["9200", "9201", "9203"]
  }
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22", "35.235.240.0/20"]
  target_tags   = ["boundary-controller"]

  description = "Allow GCP load balancer health checks to controllers"
}

