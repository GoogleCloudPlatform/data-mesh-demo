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

JOB_IDS=$(gcloud dataflow jobs list --region ${GCP_REGION} --project ${PROJECT_ID} \
  --format='value(id)' --filter="state=Running AND name:data-generator-*")

if [ -z "${JOB_IDS}" ]
then
  echo "No running data generator Dataflow job found. If you just launched it - you might need to wait a couple of minutes."
else
  echo "Canceling Dataflow job(s): ${JOB_IDS}"
  gcloud dataflow jobs cancel ${JOB_IDS} --region ${GCP_REGION} --project ${PROJECT_ID}
fi

