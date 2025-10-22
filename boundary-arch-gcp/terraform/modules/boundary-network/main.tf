# boundary-vpc
resource "google_compute_network" "vpc_network" {
  name = "boundary-network"
}

# boundary-subnet
