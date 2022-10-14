terraform {
  required_providers {
    google = {
      source  = "google"
      version = "~> 4.21.0"
    }
  }
}

provider "google" {
  impersonate_service_account = var.tagger_sa
}

