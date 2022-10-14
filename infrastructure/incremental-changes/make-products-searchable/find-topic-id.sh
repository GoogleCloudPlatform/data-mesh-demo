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

CLOUDSDK_AUTH_ACCESS_TOKEN=$(gcloud auth application-default print-access-token) \
gcloud data-catalog entries lookup --format json \
 --billing-project ${TF_VAR_domain_product_project_id} \
 "pubsub.topic.\`${TF_VAR_domain_product_project_id}\`.\`${TF_VAR_product_topic_web_traffic_stats_v1_name}\`" \
 | jq -r .name
