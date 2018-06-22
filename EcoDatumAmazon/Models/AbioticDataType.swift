//
//  AbioticDataType.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum AbioticDataType {
  
  case Air([AirDataType])
  case Soil([SoilDataType])
  case Water([WaterDataType])
  
  static let all: [AbioticDataType] = [
    .Air(AirDataType.all),
    .Soil(SoilDataType.all),
    .Water(WaterDataType.all)
  ]
  
}
