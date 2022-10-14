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

BASE_DATA_PROJECT="${TF_VAR_domain_data_project_id}"
FQ_DATASET="${BASE_DATA_PROJECT}.base"


SQL_STATEMENT=''
DELIMITER=''
for (( i = 0; i < 5; i++ )); do
     SQL_STATEMENT="${SQL_STATEMENT}${DELIMITER}
      INSERT INTO \`${FQ_DATASET}.events0\` (
     request_ts, bytes_sent, random_id, bytes_received, dst_hostname,
      dst_ip, dst_port, src_ip, user_id) VALUES
      (CURRENT_TIMESTAMP, 23${i}, 23423.23, 456, 'host234', '12${i}.234.456.456', 443, '67${i}.345.234.1', 'user${i}')"
      DELIMITER=';'
done
bq query --use_legacy_sql=false --project_id ${BASE_DATA_PROJECT} ${SQL_STATEMENT}



