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

#set -e
#set -u

clean_up () {
    set +e
    set +u
}
trap clean_up EXIT

central_catalog_outputs=( \
  tag_template_id_product tag_template_name_product \
  tag_template_id_freshness tag_template_name_freshness \
  tag_template_id_well_known_id tag_template_name_well_known_id \
  tag_template_id_pubsub_topic_product tag_template_name_pubsub_topic_product \
  )
for output in "${central_catalog_outputs[@]}"
do
	source bin/set-tf-output-as-env-var.sh 'central-catalog' ${output}
done

domain_outputs=( \
  tagger_sa \
  product_events_v1_dataset \
  product_events_v1_event0 \
  product_base_dataset \
  product_base_table_event0 \
  pubsub_schema_web_traffic_stats_v1 \
  product_topic_web_traffic_stats_v1_id \
  product_topic_web_traffic_stats_v1_name \
  )
for output in "${domain_outputs[@]}"
do
	source bin/set-tf-output-as-env-var.sh 'domain' ${output}
done

consumer_outputs=( \
  consumer_sa
  )
for output in "${consumer_outputs[@]}"
do
	source bin/set-tf-output-as-env-var.sh 'consumer' ${output}
done

clean_up
