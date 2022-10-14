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

outputs=( producer_dataflow_sa producer_dataflow_temp_bucket event_generator_template \
  producer_dataflow_region producer_input_topic producer_input_subscription)
for output in "${outputs[@]}"
do
	source ../infrastructure/bin/set-tf-output-as-env-var.sh 'ingest-infrastructure' ${output}
done
