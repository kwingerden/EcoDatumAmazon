//
//  WaterDataType.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum WaterDataType: String, Codable {
  
  case Conductivity
  case DissolvedOxygen = "Dissolved Oxygen"
  case FlowRate = "Flow Rate"
  case Nitrate
  case Odor
  case PAR
  case pH
  case Phosphate
  case Temperature
  case Turbidity
  
  static let all: [WaterDataType] = [
    .Conductivity,
    .DissolvedOxygen,
    .FlowRate,
    .Nitrate,
    .Odor,
    .PAR,
    .pH,
    .Phosphate,
    .Temperature,
    .Turbidity
  ]
  
}
