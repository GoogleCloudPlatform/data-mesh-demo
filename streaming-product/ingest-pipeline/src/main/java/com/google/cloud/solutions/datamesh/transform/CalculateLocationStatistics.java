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

import com.google.cloud.solutions.datamesh.model.EnrichedClick;
import com.google.cloud.solutions.datamesh.model.LocationStats;
import org.apache.beam.sdk.coders.RowCoder;
import org.apache.beam.sdk.transforms.Count;
import org.apache.beam.sdk.transforms.DoFn;
import org.apache.beam.sdk.transforms.PTransform;
import org.apache.beam.sdk.transforms.ParDo;
import org.apache.beam.sdk.transforms.windowing.IntervalWindow;
import org.apache.beam.sdk.transforms.windowing.SlidingWindows;
import org.apache.beam.sdk.transforms.windowing.Window;
import org.apache.beam.sdk.values.KV;
import org.apache.beam.sdk.values.PCollection;
import org.apache.beam.sdk.values.Row;
import org.joda.time.Duration;

public class CalculateLocationStatistics extends
    PTransform<PCollection<EnrichedClick>, PCollection<Row>> {

  @Override
  public PCollection<Row> expand(PCollection<EnrichedClick> input) {
    return input
        .apply("Every 15 minutes", Window.into(
            SlidingWindows.of(Duration.standardMinutes(15)).every(Duration.standardMinutes(5))))
        .apply("Key by Location", ParDo.of(new DoFn<EnrichedClick, KV<String, Boolean>>() {
          @ProcessElement
          public void process(@Element EnrichedClick enrichedClick,
              OutputReceiver<KV<String, Boolean>> outputReceiver) {
            outputReceiver.output(
                // KV.of(Location.create(enrichedClick.getString(Click.SOURCE_COUNTRY),
                //     enrichedClick.getString(Click.SOURCE_REGION)), Boolean.TRUE));
                KV.of(enrichedClick.getSourceCountry() + '-' +
                    enrichedClick.getSourceRegion(), Boolean.TRUE));
          }
        }))
        // .setCoder(KvCoder.of(SerializableCoder.of(Location.class),
        //     BooleanCoder.of()))
        .apply("Count locations", Count.perKey())
        .apply("Convert to Row", ParDo.of(new DoFn<KV<String, Long>, Row>() {
          @ProcessElement
          public void convert(@Element KV<String, Long> stats, IntervalWindow window,
              OutputReceiver<Row> outputReceiver) {
            String key = stats.getKey();
            String[] splitKey = key.split("-");
            String country = splitKey[0];
            String region = splitKey[1];
            Row result = Row.withSchema(LocationStats.SCHEMA)
                .withFieldValue(LocationStats.COUNTRY, country)
                .withFieldValue(LocationStats.REGION, region)
                .withFieldValue(LocationStats.START_TIMESTAMP, window.start())
                .withFieldValue(LocationStats.END_TIMESTAMP, window.end())
                .withFieldValue(LocationStats.COUNT, stats.getValue())
                .build();
            outputReceiver.output(result);
          }
        })).setCoder(RowCoder.of(LocationStats.SCHEMA));
  }
}
