#!/usr/bin/env bash

#
# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e
set -u

# Create initial projects

# Assumes that bootstrap.sh will provide all the variables needed by the script.
source bootstrap.sh
cd initial-project-setup
terraform init
terraform apply
cd ..

# Store the project ids and admin SA accounts in env. variables with TF_VAR_ prefixes
source get-project-ids.sh

# Populate the projects with the initial data mesh constructs
cd domain
terraform init
terraform apply
cd ..

cd central-catalog
terraform init
terraform apply
cd ..

cd consumer
terraform init
terraform apply
cd ..

# Store additional resource ids in env. variables
source get-base-project-details.sh

# Apply incremental changes
cd incremental-changes

cd allow-producer-to-tag
terraform init
terraform apply
cd ..

cd make-products-searchable
# The only way to make find out the catalog ids of a BigQuery datasets/tables is to look up
source get-catalog-ids.sh
terraform init
terraform apply
cd ..

cd give-access-to-event-v1
terraform init
terraform apply
cd ..

# go to the top level
cd ..



