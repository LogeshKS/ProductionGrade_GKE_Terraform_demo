terraform {
  required_providers {
    google ={
        source = "hashicorp/google"
        version = "~>=6.0"
    }
  }
}

provider "google" {
  region = var.region
  credentials = file(var.credentials_path)
  project = var.hostprojectid
  zone = var.zone
}