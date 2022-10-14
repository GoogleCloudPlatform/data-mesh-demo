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

import com.google.auto.value.AutoValue;
import org.apache.beam.sdk.schemas.AutoValueSchema;
import org.apache.beam.sdk.schemas.annotations.DefaultSchema;
import org.apache.beam.sdk.schemas.annotations.SchemaFieldName;
import org.joda.time.Instant;

@DefaultSchema(AutoValueSchema.class)
@AutoValue
public abstract class Click {
  @SchemaFieldName(ClickSchema.REQUEST_TIME)
  public abstract Instant getRequestTimestamp();
  @SchemaFieldName(ClickSchema.IP_ADDR)
  public abstract String getIpAddress();
  @SchemaFieldName(ClickSchema.URL)
  public abstract String getPageId();
  @SchemaFieldName(ClickSchema.CUSTOMER_ID)
  public abstract String getCustomerId();

  public static Builder builder() {
    return new AutoValue_Click.Builder();
  }

  @AutoValue.Builder
  public abstract static class Builder {

    public abstract Builder setRequestTimestamp(Instant value);

    public abstract Builder setIpAddress(String value);

    public abstract Builder setPageId(String value);

    public abstract Builder setCustomerId(String value);

    public abstract Click build();
  }
}
