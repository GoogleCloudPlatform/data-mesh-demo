resource "google_project" "consumer" {
  project_id      = local.consumer_project_id
  folder_id       = var.folder_id
  billing_account = var.billing_id
  name            = "Product Consumer Apps"
}