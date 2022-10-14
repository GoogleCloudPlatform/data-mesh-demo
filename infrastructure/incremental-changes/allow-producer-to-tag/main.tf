terraform {
  required_providers {
    google = {
      source  = "google"
      version = "~> 4.21.0"
    }
  }
}

provider "google" {
  project = var.central_catalog_project_id
  impersonate_service_account = var.central_catalog_admin_sa
}

# TODO: use iteration to make it less verbose
resource "google_data_catalog_tag_template_iam_member" "tagger_sa_product_user" {
  tag_template = var.tag_template_id_product
  role = "roles/datacatalog.tagTemplateUser"
  member = "serviceAccount:${var.tagger_sa}"
}

resource "google_data_catalog_tag_template_iam_member" "tagger_sa_data_quality_user" {
  tag_template = var.tag_template_id_freshness
  role = "roles/datacatalog.tagTemplateUser"
  member = "serviceAccount:${var.tagger_sa}"
}

resource "google_data_catalog_tag_template_iam_member" "tagger_sa_well_known_id_user" {
  tag_template = var.tag_template_id_well_known_id
  role = "roles/datacatalog.tagTemplateUser"
  member = "serviceAccount:${var.tagger_sa}"
}

resource "google_data_catalog_tag_template_iam_member" "tagger_sa_pubsub_topic_product_user" {
  tag_template = var.tag_template_id_pubsub_topic_product
  role = "roles/datacatalog.tagTemplateUser"
  member = "serviceAccount:${var.tagger_sa}"
}



