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

PROJECT_ID=${TF_VAR_domain_data_project_id}
GCP_REGION=${TF_VAR_producer_dataflow_region}

JOB_NAME=product-pipeline

./stop-dataflow-pipeline.sh ${GCP_REGION} ${PROJECT_ID} ${JOB_NAME}

