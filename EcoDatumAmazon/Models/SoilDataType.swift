//
//  SoilDataType.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum SoilDataType: String, Codable {
  
  case Nitrogen
  case Phosphorus
  case Potassium
  case Moisture
  case Texture
  case Temperature
  
  static let all: [SoilDataType] = [
    .Nitrogen,
    .Phosphorus,
    .Potassium,
    .Moisture,
    .Texture,
    .Temperature
  ]
  
}
