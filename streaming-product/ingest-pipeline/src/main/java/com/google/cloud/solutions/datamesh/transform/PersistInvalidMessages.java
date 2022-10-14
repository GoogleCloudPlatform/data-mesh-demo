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

import com.google.api.services.bigquery.model.TableRow;
import com.google.cloud.solutions.datamesh.ProductPipeline;
import com.google.cloud.solutions.datamesh.model.InvalidPubSubMessage;
import java.nio.charset.StandardCharsets;
import org.apache.beam.sdk.io.gcp.bigquery.BigQueryIO;
import org.apache.beam.sdk.io.gcp.bigquery.BigQueryIO.Write.CreateDisposition;
import org.apache.beam.sdk.io.gcp.bigquery.BigQueryIO.Write.WriteDisposition;
import org.apache.beam.sdk.io.gcp.bigquery.BigQueryUtils;
import org.apache.beam.sdk.transforms.DoFn;
import org.apache.beam.sdk.transforms.InferableFunction;
import org.apache.beam.sdk.transforms.MapElements;
import org.apache.beam.sdk.transforms.PTransform;
import org.apache.beam.sdk.transforms.ParDo;
import org.apache.beam.sdk.values.PCollection;
import org.apache.beam.sdk.values.POutput;
import org.apache.beam.sdk.values.Row;

public class PersistInvalidMessages extends
    PTransform<PCollection<Row>, POutput> {

  private final static long serialVersionUID = 1L;

  private final String invalidMessagesTable;
  private final String datasetName;

  public PersistInvalidMessages(String datasetName, String invalidMessagesTable) {
    this.datasetName = datasetName;
    this.invalidMessagesTable = invalidMessagesTable;
  }

  @Override
  public POutput expand(PCollection<Row> input) {

    return input
        // .apply("Row to TableRow", MapElements.via(new InferableFunction<Row, TableRow>() {
        //   @Override
        //   public TableRow apply(Row input) {
        //     // Custom metric to make observability easier.
        //     ProductPipeline.rejectedMessages.inc();
        //     return BigQueryUtils.toTableRow(input);
        //   }
        // }))
        // .apply("Save Invalid to BigQuery", BigQueryIO.writeTableRows()
        //     .to(datasetName + '.' + invalidMessagesTable)
        //     .withWriteDisposition(WriteDisposition.WRITE_APPEND)
        //     .withCreateDisposition(CreateDisposition.CREATE_NEVER));
        .apply("Save Invalid to BigQuery", ParDo.of(new DoFn<Row, Void>() {
          @ProcessElement
          public void process(@Element Row row) {
            ProductPipeline.rejectedMessages.inc();
            if (row.hashCode() % 100 == 0) {
              ProductPipeline.LOG.error("Invalid message: " + row);
            }
          }
        }));
  }

  static class InvalidPubSubToTableRow extends DoFn<InvalidPubSubMessage, TableRow> {

    private final static long serialVersionUID = 1L;

    @ProcessElement
    public void process(@Element InvalidPubSubMessage message, OutputReceiver<TableRow> out) {
      TableRow row = new TableRow();
      row.set("published_ts", message.getPublishTime().toString());
      row.set("message_id", message.getMessageId());
      row.set("payload_bytes", message.getPayload());
      row.set("payload_string", new String(message.getPayload(), StandardCharsets.UTF_8));
      row.set("failure_reason", message.getFailureReason());
      out.output(row);
    }
  }
}
