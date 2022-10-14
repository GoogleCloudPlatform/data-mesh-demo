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

package com.google.cloud.solutions.datamesh.transform;

import org.apache.beam.sdk.io.gcp.pubsub.PubsubIO;
import org.apache.beam.sdk.transforms.PTransform;
import org.apache.beam.sdk.transforms.ToJson;
import org.apache.beam.sdk.values.PCollection;
import org.apache.beam.sdk.values.PDone;
import org.apache.beam.sdk.values.Row;

public class SendLocationStatistics extends PTransform<PCollection<Row>, PDone> {
  private final String topic;
  public SendLocationStatistics(String topic) {
    this.topic = topic;
  }

  @Override
  public PDone expand(PCollection<Row> input) {
    input
        .apply("To Json Payload", ToJson.of())
        .apply("Send PubSub Message", PubsubIO.writeStrings().to(topic));
    return PDone.in(input.getPipeline());
  }
}
