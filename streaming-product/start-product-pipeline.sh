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

cd ingest-pipeline

PROJECT_ID=${TF_VAR_domain_data_project_id}
GCP_REGION=${TF_VAR_producer_dataflow_region}
EVENT_SUB=${TF_VAR_producer_input_subscription}
DATASET=${TF_VAR_product_base_dataset}
WEB_TRAFFIC_STATS_TOPIC=${TF_VAR_product_topic_web_traffic_stats_v1_id}
SERVICE_ACCOUNT=${TF_VAR_producer_dataflow_sa}
DATAFLOW_TEMP=gs://${TF_VAR_producer_dataflow_temp_bucket}/temp

JOB_NAME=product-pipeline

./gradlew run --args="\
 --jobName=${JOB_NAME}\
 --project=${PROJECT_ID}\
 --region=${GCP_REGION} \
 --maxNumWorkers=3 \
 --runner=DataflowRunner \
 --streaming=true \
 --subscriptionId=${EVENT_SUB} \
 --datasetProjectId=${PROJECT_ID} \
 --datasetName=${DATASET} \
 --webTrafficStatsTopic=${WEB_TRAFFIC_STATS_TOPIC} \
 --serviceAccount=${SERVICE_ACCOUNT} \
 --tempLocation=${DATAFLOW_TEMP} \
 --enableStreamingEngine \
 --diskSizeGb=30"

