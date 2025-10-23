output "vpc_self_link" {
  value       = google_compute_network.boundary_vpc.self_link
  description = "The self_link of the created VPC network."
}
