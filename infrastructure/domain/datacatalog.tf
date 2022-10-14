resource "google_data_catalog_taxonomy" "data_categorization" {
  project = var.domain_data_project_id
  provider = google-beta
  region = "us"
  display_name =  "Data categorization"
  description = "Policy tags related to data categorization"
  activated_policy_types = ["FINE_GRAINED_ACCESS_CONTROL"]
  depends_on = [google_project_service.datacatalog_api_data]
}

resource "google_data_catalog_policy_tag" "high_security" {
  provider = google-beta
  taxonomy = google_data_catalog_taxonomy.data_categorization.id
  display_name = "High"
  description = "A policy tag category used for high security access"
  depends_on = [google_project_service.datacatalog_api_data]
}

resource "google_data_catalog_policy_tag" "customer_id" {
  provider = google-beta
  taxonomy = google_data_catalog_taxonomy.data_categorization.id
  display_name = "Customer id"
  description = "Customer id, should only be accessed on as-needed basis"
  parent_policy_tag = google_data_catalog_policy_tag.high_security.id
  depends_on = [google_project_service.datacatalog_api_data]
}


