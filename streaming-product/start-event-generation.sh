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
EVENT_TOPIC=${TF_VAR_producer_input_topic}
EVENT_GENERATOR_TEMPLATE=${TF_VAR_event_generator_template}

QPS=$1
JOB_NAME=data-generator-${QPS}
gcloud dataflow flex-template run ${JOB_NAME} \
    --project=${PROJECT_ID} \
    --region=${GCP_REGION} \
    --template-file-gcs-location=gs://dataflow-templates/latest/flex/Streaming_Data_Generator \
    --parameters schemaLocation=${EVENT_GENERATOR_TEMPLATE} \
    --parameters qps=${QPS} \
    --parameters topic=${EVENT_TOPIC}
