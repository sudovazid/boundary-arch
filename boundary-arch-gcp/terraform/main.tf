terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}
provider "google" {
  project     = var.project-id
  region      = var.region
  zone        = var.zone
  credentials = file("~/.config/gcloud/adc-personal.json")
}