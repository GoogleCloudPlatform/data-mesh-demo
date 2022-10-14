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

package com.google.cloud.solutions.datamesh.service;

import com.google.cloud.solutions.datamesh.model.Location;
import java.io.Serializable;

public class IpLocationResolver {
  public Location resolve(String ipAddress) {
      return locations[Math.abs(ipAddress.hashCode() % locations.length)];
  }

  public static Location[] locations = new Location[] {
      Location.create("USA", "CA"),
      Location.create("USA", "AZ"),
      Location.create("USA", "NV"),
      Location.create("USA", "MI"),
      Location.create("USA", "AL"),
      Location.create("USA", "SC"),
      Location.create("USA", "FL"),
      Location.create("USA", "CA"),
      Location.create("USA", "IN"),
      Location.create("USA", "TX"),
      Location.create("USA", "NC"),
      Location.create("USA", "WI"),
      Location.create("USA", "OR"),
      Location.create("USA", "WA"),
      Location.create("Canada", "AB"),
      Location.create("Canada", "BC"),
      Location.create("Canada", "MB"),
      Location.create("Canada", "NB"),
      Location.create("Canada", "ON"),
      Location.create("Mexico", "AG"),
      Location.create("Mexico", "BC"),
      Location.create("Mexico", "CO"),
      Location.create("Mexico", "DF"),
      Location.create("Mexico", "JA"),
  };
}
