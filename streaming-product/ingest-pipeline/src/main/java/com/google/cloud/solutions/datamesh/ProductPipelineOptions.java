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

import org.apache.beam.runners.dataflow.options.DataflowPipelineOptions;
import org.apache.beam.sdk.options.Default;
import org.apache.beam.sdk.options.Description;
import org.apache.beam.sdk.options.Validation;
import org.apache.beam.sdk.options.Validation.Required;

/**
 * Interface to store pipeline options provided by the user
 */
public interface ProductPipelineOptions extends DataflowPipelineOptions {

  @Description("Pub/Sub subscription to receive raw messages from")
  String getSubscriptionId();

  void setSubscriptionId(String value);

  @Description("BigQuery dataset project id")
  @Validation.Required
  String getDatasetProjectId();

  void setDatasetProjectId(String value);

  @Description("BigQuery dataset")
  @Validation.Required
  String getDatasetName();

  void setDatasetName(String value);

  @Description("Table name for main events")
  @Validation.Required
  @Default.String("clicks")
  String getClicksTable();

  void setClicksTable(String value);


  @Description("Table name for invalid messages")
  @Required
  @Default.String("invalid_messages")
  String getInvalidMessagesTable();
  void setInvalidMessagesTable(String value);

  @Description("Topic for composite analytics")
  String getAnalyticsTopic();
  void setAnalyticsTopic(String value);

  @Description("Topic for web traffic statistics")
  @Required
  String getWebTrafficStatsTopic();
  void setWebTrafficStatsTopic(String value);
}

