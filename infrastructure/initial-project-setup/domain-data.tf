resource "google_project" "domain_data" {
  project_id      = local.domain_data_project_id
  folder_id       = var.folder_id
  billing_account = var.billing_id
  name            = "Domain Data"
}