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

import com.google.cloud.solutions.datamesh.ProductPipeline.PipelineInputs;
import com.google.cloud.solutions.datamesh.ProductPipeline.PipelineOutputs;
import com.google.cloud.solutions.datamesh.model.EnrichedClick;
import com.google.cloud.solutions.datamesh.model.Location;
import com.google.cloud.solutions.datamesh.service.IpLocationResolver;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;
import org.apache.beam.sdk.io.gcp.pubsub.PubsubMessage;
import org.apache.beam.sdk.io.gcp.pubsub.PubsubMessageWithAttributesAndMessageIdCoder;
import org.apache.beam.sdk.schemas.Schema;
import org.apache.beam.sdk.schemas.Schema.Field;
import org.apache.beam.sdk.schemas.Schema.FieldType;
import org.apache.beam.sdk.testing.PAssert;
import org.apache.beam.sdk.testing.TestPipeline;
import org.apache.beam.sdk.testing.TestStream;
import org.apache.beam.sdk.transforms.ToJson;
import org.apache.beam.sdk.values.Row;
import org.joda.time.Duration;
import org.joda.time.Instant;
import org.junit.Assert;
import org.junit.Rule;
import org.junit.Test;


public class ProductPipelineTest {

  @Rule
  public final transient TestPipeline testPipeline = TestPipeline.create();

  @Test
  public void testMainFlow() {
    Instant eventPublishTime = new Instant();

    PipelineInputs inputs = new PipelineInputs();

    Object[][] testData = new Object[][]{
        {eventPublishTime, "user1", "1.1.1.1", "/page1"},
        {eventPublishTime, "user1", "1.1.1.1", "/page2"},
        {eventPublishTime, "user1", "1.1.1.1", "/page3"},
        {eventPublishTime, "user1", "1.1.1.1", "/page4"},
        {eventPublishTime, "user2", "1.1.1.2", "/page2"},
    };

    PubsubMessage invalidMessage = pubsubMessage("junk");

    PubsubMessage[] validMessages = new PubsubMessage[]{
        validMessage(eventPublishTime, "user1", "1.1.1.1", "/page1"),
        validMessage(eventPublishTime, "user2", "1.1.1.2", "/page2"),

    };

    Set<EnrichedClick> expectedClick = new HashSet<>();
    Arrays.stream(testData).forEach(d -> {

      IpLocationResolver ipLocationResolver = new IpLocationResolver();
      String ipAddress = (String) d[2];
      Location location = ipLocationResolver.resolve(ipAddress);
      expectedClick.add(EnrichedClick.builder()
          .setRequestTimestamp((Instant) d[0])
          .setCustomerId((String) d[1])
          .setIpAddress(ipAddress)
          .setPageId((String) d[3])
          .setSourceCountry(location.getCountry())
          .setSourceRegion(location.getRegion())
          .build());
    });

    TestStream.Builder<PubsubMessage> messageFlow = TestStream
        .create(PubsubMessageWithAttributesAndMessageIdCoder.of())
        .advanceWatermarkTo(eventPublishTime);

    messageFlow = messageFlow.addElements(invalidMessage);
    for (Object[] d : testData) {
      PubsubMessage m = validMessage((Instant) d[0], (String) d[1], (String) d[2], (String) d[3]);
      messageFlow =
          messageFlow
              .advanceWatermarkTo(eventPublishTime.plus(Duration.standardSeconds(1)))
              .addElements(m);
    }

    // Needed to force the processing time based timers.
    messageFlow = messageFlow.advanceProcessingTime(Duration.standardMinutes(5));

    inputs.rawPubSubMessages = testPipeline
        .apply("Create Clicks", messageFlow.advanceWatermarkToInfinity());

    PipelineOutputs outputs = ProductPipeline.mainProcessing(inputs);

    // Check enriched clicks
    PAssert.that("Enriched clicks", outputs.enrichedClicks).satisfies(clicks -> {
      int count = 0;

      for (EnrichedClick click : clicks) {
        Assert.assertTrue("Click exists", expectedClick.contains(click));
        count++;
      }
      Assert.assertEquals("Expected click count", expectedClick.size(), count);
      return null;
    });

    // Check failed messages
    PAssert.that("Failed PubSub message size", outputs.invalidMessages).satisfies(rows -> {
      int count = 0;
      for (Row failedMessage : rows) {
        count++;
      }
      Assert.assertEquals("Expected failed record count", 1, count);
      return null;
    });
    PAssert.that("Failed pubsub messages", outputs.invalidMessages).containsInAnyOrder(
        Row.withSchema(Schema.of(
                Field.of("line", FieldType.STRING), Field.of("err", FieldType.STRING)))
            .withFieldValue("line", new String(invalidMessage.getPayload(), StandardCharsets.UTF_8))
            .withFieldValue("err", "Unable to parse Row")
            .build()
    );

    PAssert.that("Stats are aggregated", outputs.locationStats).satisfies(rows -> {
      for (Row stat : rows) {
        System.out.println(stat);
      }
      return null;
    });

    PAssert.that("Stats toJson are correct", outputs.locationStats.apply("ToJson", ToJson.of()))
        .satisfies(rows -> {
          for (String jsonPayload : rows) {
            System.out.println(jsonPayload);
          }
          return null;
        });

    testPipeline.run();
  }

  static PubsubMessage pubsubMessage(String payload) {
    return new PubsubMessage(payload.getBytes(), null, UUID.randomUUID().toString());
  }

  static PubsubMessage validMessage(Instant instant, String customerId, String ip, String url) {
    String json = "{"
        + "\"request_time\":" + instant.getMillis() + ','
        + "\"customer_id\":" + '"' + customerId + '"' + ','
        + "\"ip_addr\":" + '"' + ip + '"' + ','
        + "\"url\":" + '"' + url + '"'
        + "}";

    return pubsubMessage(json);
  }
}