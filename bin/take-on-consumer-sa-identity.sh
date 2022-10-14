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

PRODUCT_READER_SA=${TF_VAR_consumer_sa}
ACTIVE_AUTH=$(gcloud auth list  --filter=status:ACTIVE --format="value(account)")

if [ "${PRODUCT_READER_SA}" = "${ACTIVE_AUTH}" ]; then
    echo "Current auth is already set to ${PRODUCT_READER_SA}."
    exit 0
fi

echo "Creating key for ${PRODUCT_READER_SA}..."
KEY_FILE=sa-key.json

gcloud iam service-accounts keys create ${KEY_FILE} --iam-account=${PRODUCT_READER_SA}

ORIGINAL_ACTIVE_ACCOUNT_FILE='original_active_account'
gcloud auth list --format "value(account)" --filter="status: 'ACTIVE'" > ${ORIGINAL_ACTIVE_ACCOUNT_FILE}

gcloud auth activate-service-account ${PRODUCT_READER_SA} --key-file=${KEY_FILE}
