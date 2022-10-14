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
import com.google.cloud.solutions.datamesh.model.EnrichedClick;
import org.apache.beam.sdk.io.gcp.bigquery.BigQueryIO;
import org.apache.beam.sdk.io.gcp.bigquery.BigQueryIO.Write;
import org.apache.beam.sdk.io.gcp.bigquery.BigQueryIO.Write.CreateDisposition;
import org.apache.beam.sdk.io.gcp.bigquery.BigQueryIO.Write.WriteDisposition;
import org.apache.beam.sdk.io.gcp.bigquery.BigQueryStorageApiInsertError;
import org.apache.beam.sdk.io.gcp.bigquery.BigQueryUtils;
import org.apache.beam.sdk.io.gcp.bigquery.WriteResult;
import org.apache.beam.sdk.transforms.DoFn;
import org.apache.beam.sdk.transforms.InferableFunction;
import org.apache.beam.sdk.transforms.MapElements;
import org.apache.beam.sdk.transforms.PTransform;
import org.apache.beam.sdk.transforms.ParDo;
import org.apache.beam.sdk.values.PCollection;
import org.apache.beam.sdk.values.PDone;
import org.apache.beam.sdk.values.POutput;
import org.apache.beam.sdk.values.Row;

public class PersistEnrichedClicks extends PTransform<PCollection<EnrichedClick>, PDone> {

  private final static long serialVersionUID = 1L;

  private final String projectId;
  private final String datasetName;
  private final String clicksTable;

  public PersistEnrichedClicks(String projectId, String datasetName, String clicksTable) {
    this.projectId = projectId;
    this.datasetName = datasetName;
    this.clicksTable = clicksTable;
  }

  @Override
  public PDone expand(PCollection<EnrichedClick> input) {
    WriteResult writeResult = input
        .apply("Row to TableRow", MapElements.via(new InferableFunction<EnrichedClick, TableRow>() {
          @Override
          public TableRow apply(EnrichedClick input) throws Exception {
            TableRow result = new TableRow();
            result
                .set("request_time", input.getRequestTimestamp())
                .set("customer_id", input.getCustomerId())
                .set("ip_addr", input.getIpAddress())
                .set("url", input.getPageId())
                .set("source_country", input.getSourceCountry())
                .set("source_region", input.getSourceRegion());
            return result;
          }
        }))
        .apply("Save Click to BigQuery", BigQueryIO.writeTableRows()
            .to(projectId + '.' + datasetName + '.' + clicksTable)
            .withMethod(Write.Method.STORAGE_API_AT_LEAST_ONCE)
            .withExtendedErrorInfo()
            .withWriteDisposition(WriteDisposition.WRITE_APPEND)
            .withCreateDisposition(CreateDisposition.CREATE_NEVER));

    // In production logging directly is a bad idea. Here it's done for illustration purposes only
    writeResult.getFailedStorageApiInserts()
        .apply("Process Insert Failure",
            ParDo.of(new DoFn<BigQueryStorageApiInsertError, String>() {
              @ProcessElement
              public void process(@Element BigQueryStorageApiInsertError error) {
                ProductPipeline.failedToInsert.inc();
                ProductPipeline.LOG.error(
                    "Failed to insert: " + error.getErrorMessage() + ", row: " + error.getRow());
              }
            })
        );
    return PDone.in(input.getPipeline());
  }
}
