terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}
provider "google" {
  project = var.project_id
  region  = var.region
}

#Terraform backend bucket
resource "google_storage_bucket" "terraform_state_bucket" {
  name          = "${var.bucket_name}-${var.project_id}"
  location      = var.region
  force_destroy = true
  versioning {
    enabled = true
  }
}
