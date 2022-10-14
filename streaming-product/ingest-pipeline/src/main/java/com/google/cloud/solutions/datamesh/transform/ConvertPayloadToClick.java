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

import static com.google.cloud.solutions.datamesh.ProductPipeline.totalMessages;

import com.google.cloud.solutions.datamesh.model.Click;
import com.google.cloud.solutions.datamesh.model.ClickSchema;
import java.nio.charset.StandardCharsets;
import org.apache.beam.sdk.io.gcp.pubsub.PubsubMessage;
import org.apache.beam.sdk.schemas.transforms.Convert;
import org.apache.beam.sdk.transforms.DoFn;
import org.apache.beam.sdk.transforms.InferableFunction;
import org.apache.beam.sdk.transforms.JsonToRow;
import org.apache.beam.sdk.transforms.JsonToRow.ParseResult;
import org.apache.beam.sdk.transforms.MapElements;
import org.apache.beam.sdk.transforms.PTransform;
import org.apache.beam.sdk.transforms.ParDo;
import org.apache.beam.sdk.values.PCollection;
import org.apache.beam.sdk.values.PCollectionTuple;
import org.apache.beam.sdk.values.Row;
import org.apache.beam.sdk.values.TupleTag;
import org.joda.time.Instant;

public class ConvertPayloadToClick extends
    PTransform<PCollection<PubsubMessage>, PCollectionTuple> {

  public static final TupleTag<Click> clicksTag = new TupleTag<>();
  public static final TupleTag<Row> failedPayloadsTag = new TupleTag<>();

  @Override
  public PCollectionTuple expand(PCollection<PubsubMessage> input) {
    ParseResult parseResult = input.apply("Payload to String",
            MapElements.via(
                new InferableFunction<PubsubMessage, String>() {
                  @Override
                  public String apply(PubsubMessage input) {
                    totalMessages.inc();
                    return new String(input.getPayload(), StandardCharsets.UTF_8);
                  }
                }))
        .apply("String To Row",
            JsonToRow.withExceptionReporting(ClickSchema.clickSchema).withExtendedErrorInfo());
    PCollection<Click> clicksP = parseResult.getResults()
        .apply("Convert to Click", ParDo.of(new DoFn<Row, Click>() {
          @ProcessElement
          public void convert(@Element Row row, OutputReceiver<Click> outputReceiver) {
            outputReceiver.output(
                Click.builder()
                    .setCustomerId(row.getValue(ClickSchema.CUSTOMER_ID))
                    .setIpAddress(row.getValue(ClickSchema.IP_ADDR))
                    .setPageId(row.getValue(ClickSchema.URL))
                    .setRequestTimestamp(Instant.ofEpochMilli(row.getValue(ClickSchema.REQUEST_TIME)))
                    .build()
            );
          }
        }));
    return PCollectionTuple.of(clicksTag, clicksP)
        .and(failedPayloadsTag, parseResult.getFailedToParseLines());
  }
}
