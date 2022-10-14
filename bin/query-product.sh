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

CONSUMING_PROJECT="${TF_VAR_consumer_project_id}"
FQ_DATASET="${TF_VAR_domain_product_project_id}.events_v1"


bin/take-on-consumer-sa-identity.sh

bq query --use_legacy_sql=false --project_id ${CONSUMING_PROJECT} \
 "SELECT DISTINCT(src_ip) from \`${FQ_DATASET}.event0\` ORDER BY src_ip LIMIT 10"



