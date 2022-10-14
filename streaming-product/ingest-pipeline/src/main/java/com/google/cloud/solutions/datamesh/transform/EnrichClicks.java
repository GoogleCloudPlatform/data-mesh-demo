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

import com.google.cloud.solutions.datamesh.model.Click;
import com.google.cloud.solutions.datamesh.model.EnrichedClick;
import com.google.cloud.solutions.datamesh.model.Location;
import com.google.cloud.solutions.datamesh.service.IpLocationResolver;
import org.apache.beam.sdk.transforms.DoFn;
import org.apache.beam.sdk.transforms.PTransform;
import org.apache.beam.sdk.transforms.ParDo;
import org.apache.beam.sdk.values.PCollection;

public class EnrichClicks extends PTransform<PCollection<Click>, PCollection<EnrichedClick>> {

  private static final long serialVersionUID = 1L;


  public EnrichClicks() {
  }

  @Override
  public PCollection<EnrichedClick> expand(PCollection<Click> input) {
    return input.apply("Enrich Click", ParDo.of(new Enricher()));
  }

  static class Enricher extends DoFn<Click, EnrichedClick> {

    @ProcessElement
    public void enrich(@Element Click click, OutputReceiver<EnrichedClick> outputReceiver) {
      IpLocationResolver ipLocationResolver = new IpLocationResolver();
      Location location = ipLocationResolver.resolve(click.getIpAddress());
      EnrichedClick result = EnrichedClick.builder()
          .setRequestTimestamp(click.getRequestTimestamp())
          .setCustomerId(click.getCustomerId())
          .setIpAddress(click.getIpAddress())
          .setPageId(click.getPageId())
          .setSourceCountry(location.getCountry())
          .setSourceRegion(location.getRegion())
          .build();
      outputReceiver.output(result);
    }
  }


}
