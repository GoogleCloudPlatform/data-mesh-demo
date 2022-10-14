terraform {
  required_providers {
    google = {
      source  = "google"
      version = "~> 4.21.0"
    }
  }
}

provider "google" {}

locals {
  catalog_project_id = "${var.project_prefix}-central-catalog"
  consumer_project_id = "${var.project_prefix}-consumer"
  domain_data_project_id = "${var.project_prefix}-domain-data"
  domain_product_project_id = "${var.project_prefix}-domain-product"
}
