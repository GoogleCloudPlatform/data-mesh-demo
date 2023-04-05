# Data Mesh on Google Cloud

## Overview

This repo is a reference implementation of Data Mesh on Google Cloud.
See [this architecture guide](https://cloud.google.com/architecture/architecture-functions-data-mesh)
for details.

[infrastructure](/infrastructure) folder contains a number of Terraform scripts
to create several Google Cloud projects which represent typical data mesh
participants - data producers, data consumers, central services. The scripts are
stored in folders and are meant to be executed sequentially to illustrate the
typical progression of building a data mesh.

## Setup

### Prerequisites

In order to run the scripts in this repo make sure you have installed:

* gcloud command ([instructions](https://cloud.google.com/sdk/docs/install))
*

Terraform ([instructions](https://learn.hashicorp.com/tutorials/terraform/install-cli))

* jq utility ([instructions](https://stedolan.github.io/jq/download/))

If you are using Cloud Shell, all these utilities are preinstalled in your
environment.

You would need to create Google Cloud's Application Default Credentials using

```shell
gcloud auth application-default login
```

#### Permissions of the principal running the Terraform scripts
Typicially a person with `Owner` or `Editor` basic roles will execute the Terraform scripts to set up the infrastructure of the Data Mesh. These scripts can also be run using a service account with sufficent privileges. 
It is important that the principal running the scripts has `Service Account Token Creator` role at the `Domain/Org level` policy rather than the project level. Without it the scripts will fail with a `403` error while creating tag templates. 


To start the data mesh infrastructure build process:

```shell
cd infrastructure
```

### Providing Terraform variables

Several step below mention that you will need to provide Terraform variables.
There are [multiple ways](https://www.terraform.io/language/values/variables) to
do this. The simplest approach is to create a short script that sets the
variables you need before you start setting the infrastructure, which you can
re-run if you need to restart your session. Typically this script will contain
several statements like:

```shell
export TF_VAR_project_prefix='my-data-mesh-demo'
```

and can be set using

```shell
source set-my-variables.sh
```

Notice, `TF_VAR_` indicates to Terraform that the rest of the environment
variable name is Terraform's variable name.

### Projects

There are 4 projects that are used in this demo. They can be existing projects,
or there are scripts to create new projects.

* Domain base data project. It contains base BigQuery tables and materialized
  views.
* Domain product project. It contains BigQuery authorized views and a Pub/Sub
  topic that constitute consumption interfaces exposed to data consumers (see
  the Consumer project, described below) as data products by this domain.
* Central catalog project. It is the project where the data mesh-specific Data
  Catalog tag templates are defined.
* Consumer project. Data from the data product is consumed from this project.

#### To create new projects

All new projects will be created in the same organization folder. In a real
organization most likely there will be multiple folders mapping to different
domains in the organization, but for simplicity in managing the newly created
projects we are creating them in the same folder.

Set up the following Terraform variables:

* project_prefix - used if creating the projects as part of the setup
* billing_id - all projects created will be using this billing id
* folder_id - all projects will be created in this folder
* org_domain - all users within this domain will be given access to search data
  products in Data Catalog

Create a new folder and capture the folder id

Ensure that the account used to run Terraform scripts has the following roles
assigned at the folder level:

* Folder Admin
* Service Account Token Creator

Run these commands:

```shell
cd initial-project-setup
terraform init
terraform apply
cd ..
```

Now that the projects are created their project ids can be stored in environment
variables by running

```shell
source get-project-ids.sh
```

#### Using existing projects

If you pre-created the four projects we mentioned earlier and would like to use
them, make sure the following Terraform variables are set:

* consumer_project_id
* domain_data_project_id
* domain_product_project_id
* central_catalog_project_id

Additionally, you would need to create a service account in the Central Catalog
project, give it at least Data Catalog Admin role and assign the Terraform
variable `central_catalog_admin_sa` its email address. The account that will be
used to run the Terraform scripts in the central catalog project will need to
have Service Account Token Creator role on this service account.

## Creating base project infrastructure

Each of these steps can be done in any sequence. It simulates typical steps done
by participants in the data mesh.

### Domain data (created by data producers)

```shell
cd domain
terraform init
terraform apply
cd ..
```

### Central catalog (created by the central services team)

```shell
cd central-catalog
terraform init
terraform apply
cd ..
```

### Consumer project (created by a data mesh consumer)

```shell
cd consumer
terraform init
terraform apply
cd ..
```

Once all the projects are populated, store additional resource ids in
environment variables:

```shell
source get-base-project-details.sh
```

## Enabling the data mesh

Next steps show how to enable the data mesh in the organization. We included
these steps in [incremental changes folder](/infrastructure/incremental-changes)

```shell
cd incremental-changes
```

### Allow producers to tag data products and underlying data resources

The central
team [defined a set of tag templates](infrastructure/central-catalog/datacatalog.tf)
needed to tag data product-related resources ("product interfaces") by data
producers. Allowing data producers to use the tag templates
requires [granting the Tag Template User role](infrastructure/incremental-changes/allow-producer-to-tag/main.tf)
to the service account(s) used to tag these resources.

```shell
cd allow-producer-to-tag
terraform init
terraform apply
cd ..
```

### Make product searchable

To make data interfaces searchable in Data Catalog two things need to happen:

* Resource metadata needs to become visible to anybody in the organization
* Resources need to be tagged with a set of predefined tag templates

`get-catalog-ids.sh` script sets several Terraform variables with the Data
Catalog ids of the resources to be tagged using the data mesh-related tag
templates.

You will need to set up this Terraform variable:

* org_domain - all users within this domain will be given access to search data
  products in Data Catalog, e.g., `example.com`.

```shell
cd make-products-searchable
source get-catalog-ids.sh
terraform init
terraform apply
cd ..
```

### Give the consumer access to a product interface

Once a product is discovered and its suitability is assessed by the consumer the
product owner needs to grant access to the resources which represent the
interface.

```shell
cd give-access-to-event-v1
terraform init
terraform apply
cd ..
```

## Single script to create all infrastructure

[build-all.sh](infrastructure/build-all.sh) script executes all the steps above.
It assumes that you will be creating projects from scratch. It assumes that all
the Terraform variables will be provided in `bootstrap.sh` script. Here's an
example of such a script:

```shell
export TF_VAR_project_prefix='my-org-mesh'
export TF_VAR_org_id='<numeric org id>'
export TF_VAR_billing_id='<billing id>'
export TF_VAR_folder_id='<numeric folder id>'
export TF_VAR_org_domain='example.com'
```

## Using Data Mesh concepts

### Searching for products in Data Catalog

Data Catalog searches are performed within scopes - either organization, folder
or project. Several scripts mentioned below use organization as the scope. You
would need to define `TF_VAR_org_id` environment variable before you can run
them. You can find the organization id you belong to by running

```shell
gcloud organizations list
```

To search for data products using Data Catalog APIs, execute this script from
the root of this repo:

```shell
bin/search-products.sh <search terms>
```

Search terms must conform
to [the Data Catalog search syntax](https://cloud.google.com/data-catalog/docs/how-to/search-reference)
. A simple search term which works for this repo is `events`. It will find
several data products defined in the domain project that contain the term "
events" in their names or descriptions.

You "undo" the data product registration in the data mesh catalog by running
this script:

```shell
terraform -chdir=infrastructure/incremental-changes/make-products-searchable destroy
```

A subsequent search of the catalog will return no results.

To make the products searchable again use:

```shell
terraform -chdir=infrastructure/incremental-changes/make-products-searchable apply
```

Also, compare this to searching the data catalog across the whole organization:

```shell
bin/search-all-org-assets.sh <search terms>
```

Depending on your organization and permissions granted to you to access the data
you will see a large number of Data Catalog entries, most of which are not ready
to be shared by the product owners with possible consumers.

### Consuming product data

Once the data product is discovered and access to it is granted to a consumer (a
service account or a user group), the product can be consumed.

#### Authorized views

In this case, access to the authorized BigQuery dataset has been granted to a
Service Account in the consumer project.

[bin](bin) folder has several scripts to test how access works:

* `bin/populate-base-table.sh` creates several records in the base table
* `bin/query-product.sh` uses a service account in the consumer project to query
  the table. You should see results similar to these:

```
+---------------+
|    src_ip     |
+---------------+
| 670.345.234.1 |
| 671.345.234.1 |
| 672.345.234.1 |
| 673.345.234.1 |
| 674.345.234.1 |
+---------------+
```

* `bin/query-product-with-column-level-ac.sh` is similar to the previous script.
  It shows that column level access control can be enforced in the data mesh at the
  base table level. This query will fail with the `Access Denied...`
  error.

When you run any of the `query-product*.sh` scripts, your gcloud authorization
will be set to use the service account in the consumer project. This validates
that the customer's service account had the intended access to query the product data.

Use `bin/remove-consumer-sa-key.sh` script to delete the service account key
created to run these scripts and make the originally active account active
again.

#### Consuming data streams

[streaming-product](streaming-product) folder contains the instructions on how
to create, discover and consume data which is exposed as a data stream.

# Cleanup

You can run `terraform destroy` in all the subfolders
of [infrastructure](/infrastructure) to revert the changed to the projects.
There is a convenience [destroy-all.sh](/infrastructure/destroy-all.sh) script
that will do it for you.

If you have created new projects for this demo you can just delete these
projects.



