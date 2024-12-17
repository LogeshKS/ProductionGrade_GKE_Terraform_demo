output "hostprojectid" {
  value = google_compute_network.vpc.id
}

output "private_subnet1ips" {
  value = google_compute_subnetwork.private_subnet1.ip_cidr_range
}

output "gke_cluster_subnetworkip" {
  value = google_compute_subnetwork.gke_cluster_subnetwork.ip_cidr_range
}

