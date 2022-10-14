resource "google_data_catalog_tag_template" "product" {
  tag_template_id = "data_product"
  region          = var.catalog_template_location

  display_name = "Data Product"

  fields {
    field_id = "data_domain"
    display_name = "Data domain"
    description = "The broad category for the data"
    order = 11
    is_required = true
    type {
      enum_type {
        allowed_values {
          display_name = "Operations"
        }
        allowed_values {
          display_name = "Sales"
        }
        allowed_values {
          display_name = "Marketing"
        }
        allowed_values {
          display_name = "Finance"
        }
        allowed_values {
          display_name = "HR"
        }
        allowed_values {
          display_name = "Legal"
        }
        allowed_values {
          display_name = "Logistics"
        }
        allowed_values {
          display_name = "Other"
        }
      }
    }
  }

  fields {
    field_id = "data_subdomain"
    display_name = "Data subdomain"
    description = "The subcategory for the data"
    is_required = false
    order = 10
    type {
      enum_type {
        allowed_values {
          display_name = "Trade_and_Banking"
        }
        allowed_values {
          display_name = "Product_Events"
        }
      }
    }
  }

  fields {
    field_id = "data_product_name"
    display_name = "Data product name"
    description = "The name of the data product"
    is_required = true
    order = 9
    type {
      primitive_type = "STRING"
    }
  }

  fields {
    field_id = "data_product_description"
    display_name = "Data product description"
    description = "Short description of the data product"
    is_required = false
    order = 8
    type {
      primitive_type = "STRING"
    }
  }

  fields {
    field_id = "business_owner"
    display_name = "Business owner"
    description = "Name of the business person who owns the data product"
    is_required = true
    order = 7
    type {
      primitive_type = "STRING"
    }
  }

  fields {
    field_id = "technical_owner"
    display_name = "Technical owner"
    description = "Name of the technical person who owns the data product"
    is_required = true
    order = 6
    type {
      primitive_type = "STRING"
    }
  }

  fields {
    field_id = "number_data_resources"
    display_name = "Number of data resources"
    description = "Number of data resources in the data product"
    is_required = false
    order = 5
    type {
      primitive_type = "DOUBLE"
    }
  }

  fields {
    field_id = "storage_location"
    display_name = "Storage location"
    description = "The storage location for the data product"
    is_required = false
    order = 4

    type {
      enum_type {
        allowed_values {
          display_name = "us-east1"
        }
        allowed_values {
          display_name = "us-central1"
        }
        allowed_values {
          display_name = "us"
        }
        allowed_values {
          display_name = "eu"
        }
        allowed_values {
          display_name = "other"
        }
      }
    }
  }

  fields {
    field_id = "documentation_link"
    display_name = "Documentation Link"
    description = "Link to helpful documentation about the data product"
    is_required = false
    order = 3
    type {
      primitive_type = "STRING"
    }
  }

  fields {
    field_id = "access_request_link"
    display_name = "Access request link"
    description = "How to request access the data product"
    is_required = false
    order = 2
    type {
      primitive_type = "STRING"
    }
  }

  fields {
    field_id = "data_product_status"
    display_name = "Data product status"
    description = "Status of the data product"
    is_required = true
    order = 1
    type {
      enum_type {
        allowed_values {
          display_name = "DRAFT"
        }
        allowed_values {
          display_name = "PENDING"
        }
        allowed_values {
          display_name = "REVIEW"
        }
        allowed_values {
          display_name = "DEPLOY"
        }
        allowed_values {
          display_name = "RELEASED"
        }
        allowed_values {
          display_name = "DEPRECATED"
        }
      }
    }
  }

  fields {
    field_id = "last_modified_date"
    display_name = "Last modified date"
    description = "The last time this annotation was modified"
    is_required = true
    order = 0
    type {
      primitive_type = "TIMESTAMP"
    }
  }

  force_delete = "true"
}

resource "google_data_catalog_tag_template" "freshness" {
  tag_template_id = "freshness"
  region          = var.catalog_template_location

  display_name = "Data Freshness"

  fields {
    field_id     = "expected_freshness"
    display_name = "Expected freshness of the data"
    type {
      primitive_type = "STRING"
    }
    is_required  = true
  }

  fields {
    field_id     = "freshness_endpoint"
    display_name = "URL of the endpoint to provide current data freshness"
    type {
      primitive_type = "STRING"
    }
    is_required  = true
  }

  fields {
    field_id     = "sla_max_delay_sec"
    display_name = "SLA - maximum number of seconds the data is delayed"
    type {
      primitive_type = "DOUBLE"
    }
  }

  fields {
    field_id     = "sla_percentage"
    display_name = "SLA - percentage maximum exceeded per measurement period"
    type {
      primitive_type = "DOUBLE"
    }
  }

  fields {
    field_id     = "sla_period"
    display_name = "SLA - measurement period"
    type {
      enum_type {
        allowed_values {
          display_name = "WEEK"
        }
        allowed_values {
          display_name = "MONTH"
        }
      }
    }
  }

  force_delete = "true"
}

resource "google_data_catalog_tag_template" "well_known_id" {
  tag_template_id = "well_known_id"
  region          = var.catalog_template_location

  display_name = "Well-known Id"

  fields {
    field_id     = "id"
    display_name = "Well-known id"
    type {
      enum_type {
        allowed_values {
          display_name = "CUSTOMER_ID"
        }
        allowed_values {
          display_name = "BUSINESS_UNIT_ID"
        }
        allowed_values {
          display_name = "PRODUCT_ID"
        }
        allowed_values {
          display_name = "SKU"
        }
      }
    }
    is_required  = true
  }

  fields {
    field_id     = "notes"
    display_name = "Notes"
    type {
      primitive_type = "STRING"
    }
    is_required  = false
  }

  force_delete = "true"
}

resource "google_data_catalog_tag_template" "pubsub_topic_product" {
  tag_template_id = "pubsub_topic_details"
  region          = var.catalog_template_location

  display_name = "PubSub Topic Details"

  fields {
    field_id     = "description"
    display_name = "Description"
    type {
      primitive_type = "STRING"
    }
    is_required  = true
  }

  fields {
    field_id     = "schema_ref"
    display_name = "Enforced PubSub topic schema"
    type {
      primitive_type = "STRING"
    }
    is_required  = false
  }

  fields {
    field_id = "schema_doc_link"
    display_name = "Link to the schema documentation"
    type {
      primitive_type = "STRING"
    }
    is_required = false
  }

  force_delete = "true"
}

# Tag Template Visibility
locals {
  all_tag_templates = tolist(
  [
    google_data_catalog_tag_template.product.tag_template_id,
    google_data_catalog_tag_template.freshness.tag_template_id,
    google_data_catalog_tag_template.well_known_id.tag_template_id,
    google_data_catalog_tag_template.pubsub_topic_product.tag_template_id
  ]
  )
}
resource "google_data_catalog_tag_template_iam_member" "template_viewer_to_all_domain_users" {
  count        = length(local.all_tag_templates)
  project      = var.central_catalog_project_id
  tag_template = local.all_tag_templates[count.index]
  role         = "roles/datacatalog.tagTemplateViewer"
  member       = "domain:${var.org_domain}"
  region       = var.catalog_template_location
}
