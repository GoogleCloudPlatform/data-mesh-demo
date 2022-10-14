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

import java.lang.reflect.Array;
import java.util.Arrays;
import java.util.stream.Stream;
import org.apache.beam.sdk.schemas.Schema;
import org.apache.beam.sdk.schemas.Schema.Field;
import org.apache.beam.sdk.schemas.Schema.FieldType;

public class ClickSchema {

  public static final String REQUEST_TIME = "request_time";
  public static final String CUSTOMER_ID = "customer_id";
  public static final String IP_ADDR = "ip_addr";
  public static final String URL = "url";
  public static final String SOURCE_COUNTRY = "source_country";
  public static final String SOURCE_REGION = "source_region";

  public static final Field[] initialsFields = new Field[]{
      Field.of(REQUEST_TIME, FieldType.INT64),
      Field.of(CUSTOMER_ID, FieldType.STRING),
      Field.of(IP_ADDR, FieldType.STRING),
      Field.of(URL, FieldType.STRING)
  };

  public static final Field[] additionalFields = new Field[]{
      Field.of(SOURCE_COUNTRY, FieldType.STRING),
      Field.of(SOURCE_REGION, FieldType.STRING)
  };

  public static final Schema clickSchema = Schema.of(initialsFields);

  public static Field[] enrichedFields = Stream
      .concat(Arrays.stream(initialsFields), Arrays.stream(additionalFields))
      .toArray(
          size -> (Field[]) Array.newInstance(initialsFields.getClass().getComponentType(), size));

  public static final Schema enrichedClickSchema = Schema.of(enrichedFields);
}
