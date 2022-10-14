terraform {
  required_providers {
    google = {
      source  = "google"
      version = "~> 4.21.0"
    }
    google-beta = {
      source  = "google-beta"
      version = "~> 4.21.0"
    }
  }
}

provider "google" {
  project = var.central_catalog_project_id
  impersonate_service_account = var.central_catalog_admin_sa
}