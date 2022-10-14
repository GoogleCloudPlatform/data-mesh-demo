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
import java.util.Map;
import javax.annotation.Nullable;
import org.apache.beam.sdk.io.gcp.pubsub.PubsubMessage;
import org.apache.beam.sdk.schemas.AutoValueSchema;
import org.apache.beam.sdk.schemas.annotations.DefaultSchema;
import org.joda.time.Instant;

@DefaultSchema(AutoValueSchema.class)
@AutoValue
public abstract class InvalidPubSubMessage {

  public abstract String getFailureReason();

  @SuppressWarnings("mutable")
  public abstract byte[] getPayload();

  @Nullable
  public abstract String getMessageId();

  @Nullable
  public abstract Map<String, String> getAttributes();

  public abstract Instant getPublishTime();

  public static InvalidPubSubMessage create(String newFailureReason, PubsubMessage message,
      Instant newPublishTime) {
    return builder()
        .setFailureReason(newFailureReason)
        .setPayload(message.getPayload())
        .setMessageId(message.getMessageId())
        .setAttributes(message.getAttributeMap())
        .setPublishTime(newPublishTime)
        .build();
  }

  public static AutoValue_InvalidPubSubMessage.Builder builder() {
    return new AutoValue_InvalidPubSubMessage.Builder();
  }

  @AutoValue.Builder
  public abstract static class Builder {

    public abstract Builder setFailureReason(String newFailureReason);

    public abstract Builder setPayload(byte[] newPayload);

    public abstract Builder setMessageId(String newMessageId);

    public abstract Builder setAttributes(Map<String, String> newAttributes);

    public abstract Builder setPublishTime(Instant newPublishTime);

    public abstract InvalidPubSubMessage build();
  }
}
