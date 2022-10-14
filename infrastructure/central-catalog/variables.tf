variable "central_catalog_project_id" {
  type = string
}

variable "central_catalog_admin_sa" {
  type = string
}

variable "catalog_template_location" {
  type    = string
  default = "us-central1"
}

variable "org_domain" {
  type = string
}