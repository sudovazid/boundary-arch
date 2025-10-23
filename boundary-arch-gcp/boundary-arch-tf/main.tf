terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
  backend "gcs" {
    bucket = "backend-tf-state-bucket-${var.project-id}"
    prefix = "terraform/state"
  }
}
provider "google" {
  project     = var.project-id
  region      = var.region
  zone        = var.zone
  credentials = file("~/.config/gcloud/adc-personal.json")
}

module "boundary-network" {
  source         = "./modules/boundary-network"
  region         = var.region
  zone           = var.zone
  project-id     = var.project-id
  vpc_name       = var.vpc_name
  public-subnet  = var.public-subnet
  private-subnet = var.private-subnet
  vault-name     = var.vault-name
}

