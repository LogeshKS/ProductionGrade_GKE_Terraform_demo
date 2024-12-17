#creting VPC in GCP host project

resource "google_compute_network" "vpc" {
    name = var.name
    project = var.hostprojectid
    auto_create_subnetworks = "false"
    routing_mode = var.routing_mode
    mtu = var.mtu
}

resource "google_compute_subnetwork" "private_subnet1" {
  name                     = var.subnet1_name
  project                  = var.hostprojectid
  ip_cidr_range            = "10.0.1.0/24"
  region                   = var.region
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = true  

  dynamic "secondary_ip_range" {
    for_each = var.subnet1_secondary_ip_ranges

    content {
      range_name    = secondary_ip_range.key
      ip_cidr_range = secondary_ip_range.value
    }
  }

}

resource "google_compute_subnetwork" "gke_cluster_subnetwork" {
  name                     = var.gke_cluster_name
  project                  = var.hostprojectid
  ip_cidr_range            = "10.0.2.0/24"
  region                   = var.region
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = true  

  dynamic "secondary_ip_range" {
    for_each = var.gke_secondary_ip_ranges

    content {
      range_name    = secondary_ip_range.key
      ip_cidr_range = secondary_ip_range.value
    }
  }
}

#router configuration

resource "google_compute_router" "router" {
  name    = var.router_name
  region  = var.region
  project = var.hostprojectid
  network = google_compute_network.vpc.self_link
}

#Nat gateway
resource "google_compute_router_nat" "natgateway" {
  name = var.nat_name
  region = var.region
  project = var.hostprojectid
  router = google_compute_router.router.self_link
  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  depends_on = [google_compute_subnetwork.private_subnet1, google_compute_subnetwork.gke_cluster_subnetwork]

}

