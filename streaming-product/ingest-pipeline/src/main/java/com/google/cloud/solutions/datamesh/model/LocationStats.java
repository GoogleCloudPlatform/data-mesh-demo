/*
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.cloud.solutions.datamesh.model;

import org.apache.beam.sdk.schemas.Schema;
import org.apache.beam.sdk.schemas.Schema.Field;
import org.apache.beam.sdk.schemas.Schema.FieldType;

public class LocationStats {

  public static final String COUNTRY = "country";
  public static final String REGION = "region";
  public static final String START_TIMESTAMP = "start_ts";
  public static final String END_TIMESTAMP = "end_ts";
  public static final String COUNT = "count";
  public static final Schema SCHEMA = Schema.of(
      Field.of(COUNTRY, FieldType.STRING),
      Field.of(REGION, FieldType.STRING),
      Field.of(START_TIMESTAMP, FieldType.DATETIME),
      Field.of(END_TIMESTAMP, FieldType.DATETIME),
      Field.of(COUNT, FieldType.INT64)
  );
}
