//
//  AbioticDataTypeChoice.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum AbioticDataTypeChoice {
  
  case Air(AirDataType)
  case Soil(SoilDataType)
  case Water(WaterDataType)
  
  static func ==(lhs: AbioticDataTypeChoice, rhs: AbioticDataTypeChoice) -> Bool {
    switch (lhs, rhs) {
    case let (.Air(v1), .Air(v2)) where v1 == v2: return true
    case let (.Soil(v1), .Soil(v2)) where v1 == v2: return true
    case let (.Water(v1), .Water(v2)) where v1 == v2: return true
    default: return false
    }
  }
  
}
