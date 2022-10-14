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

KEY_FILE=sa-key.json

KEY_ID=$(jq -r .private_key_id < ${KEY_FILE})

ORIGINAL_ACTIVE_ACCOUNT_FILE='original_active_account'

DEFAULT_AUTH=$(cat ${ORIGINAL_ACTIVE_ACCOUNT_FILE})
gcloud config set core/account ${DEFAULT_AUTH}

gcloud iam service-accounts keys delete ${KEY_ID} --iam-account ${PRODUCT_READER_SA}
gcloud auth revoke ${PRODUCT_READER_SA}

rm ${KEY_FILE}
rm ${ORIGINAL_ACTIVE_ACCOUNT_FILE}
