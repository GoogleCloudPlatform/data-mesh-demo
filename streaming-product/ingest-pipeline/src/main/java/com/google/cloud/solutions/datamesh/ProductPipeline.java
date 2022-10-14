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
package com.google.cloud.solutions.datamesh;


import com.google.cloud.solutions.datamesh.model.Click;
import com.google.cloud.solutions.datamesh.model.EnrichedClick;
import com.google.cloud.solutions.datamesh.transform.ConvertPayloadToClick;
import com.google.cloud.solutions.datamesh.transform.EnrichClicks;
import com.google.cloud.solutions.datamesh.transform.CalculateLocationStatistics;
import com.google.cloud.solutions.datamesh.transform.PersistEnrichedClicks;
import com.google.cloud.solutions.datamesh.transform.PersistInvalidMessages;
import com.google.cloud.solutions.datamesh.transform.SendLocationStatistics;
import org.apache.beam.sdk.Pipeline;
import org.apache.beam.sdk.PipelineResult;
import org.apache.beam.sdk.io.gcp.pubsub.PubsubIO;
import org.apache.beam.sdk.io.gcp.pubsub.PubsubMessage;
import org.apache.beam.sdk.io.gcp.pubsub.PubsubMessageWithAttributesAndMessageIdCoder;
import org.apache.beam.sdk.metrics.Counter;
import org.apache.beam.sdk.metrics.Metrics;
import org.apache.beam.sdk.options.PipelineOptionsFactory;
import org.apache.beam.sdk.values.PCollection;
import org.apache.beam.sdk.values.PCollectionTuple;
import org.apache.beam.sdk.values.Row;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Main class for the event processing pipeline.
 */
public class ProductPipeline {

  public static final Logger LOG = LoggerFactory.getLogger(
      ProductPipeline.class);

  public static final Counter totalMessages = Metrics
      .counter(ProductPipeline.class, "totalEvents");
  public static final Counter rejectedMessages = Metrics
      .counter(ProductPipeline.class, "rejectedMessages");
  public static final Counter failedToInsert = Metrics
      .counter(ProductPipeline.class, "failedToInsert");

  static class PipelineInputs {

    PCollection<PubsubMessage> rawPubSubMessages;
  }

  static class PipelineOutputs {

    PCollection<PubsubMessage> rawPubSubMessages;
    PCollection<EnrichedClick> enrichedClicks;
    PCollection<Row> invalidMessages;
    PCollection<Row> locationStats;
  }

  /**
   * Main entry point for executing the pipeline. This will run the pipeline asynchronously. If
   * blocking execution is required, use the {@link com.google.cloud.solutions.datamesh.ProductPipeline#run(ProductPipelineOptions)}
   * method to start the pipeline and invoke {@code result.waitUntilFinish()} on the {@link
   * PipelineResult}
   *
   * @param args The command-line arguments to the pipeline.
   */
  public static void main(String[] args) {
    ProductPipelineOptions options =
        PipelineOptionsFactory.fromArgs(args)
            .withValidation()
            .as(ProductPipelineOptions.class);

    run(options);
  }

  /**
   * Runs the pipeline
   *
   * @return result
   */
  public static PipelineResult run(ProductPipelineOptions options) {
    Pipeline pipeline = Pipeline.create(options);

    PipelineInputs inputs = getPipelineInputs(options, pipeline);

    PipelineOutputs outputs = mainProcessing(inputs);

    persistOutputs(outputs, options);

    return pipeline.run();
  }


  private static PipelineInputs getPipelineInputs(ProductPipelineOptions options,
      Pipeline pipeline) {

    PipelineInputs inputs = new PipelineInputs();

    inputs.rawPubSubMessages = pipeline.begin().apply("Read Clicks from PubSub",
        PubsubIO.readMessagesWithAttributesAndMessageId()
            .fromSubscription(options.getSubscriptionId())).setCoder(
        PubsubMessageWithAttributesAndMessageIdCoder.of());

    return inputs;
  }

  public static PipelineOutputs mainProcessing(
      PipelineInputs inputs) {
    PipelineOutputs outputs = new PipelineOutputs();
    outputs.rawPubSubMessages = inputs.rawPubSubMessages;

    PCollectionTuple conversionResult = inputs.rawPubSubMessages.apply("Parse Payload",
        new ConvertPayloadToClick());

    PCollection<Click> validClicks = conversionResult.get(ConvertPayloadToClick.clicksTag);
    outputs.invalidMessages = conversionResult.get(ConvertPayloadToClick.failedPayloadsTag);

    outputs.enrichedClicks = validClicks.apply("Enrich Clicks", new EnrichClicks());

    outputs.locationStats = outputs.enrichedClicks.apply("Generate Stats",
        new CalculateLocationStatistics());

    return outputs;
  }

  public static void persistOutputs(PipelineOutputs outputs,
      ProductPipelineOptions options) {
    outputs.enrichedClicks.apply("Persist Clicks to BQ",
        new PersistEnrichedClicks(options.getDatasetProjectId(), options.getDatasetName(), options.getClicksTable()));

    outputs.invalidMessages.apply("Process Invalid Messages",
        new PersistInvalidMessages(options.getDatasetName(), options.getInvalidMessagesTable()));

    outputs.locationStats.apply("Publish Stats",
        new SendLocationStatistics(options.getWebTrafficStatsTopic()));
  }
}
