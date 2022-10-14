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
  project = var.consumer_project_id
}
