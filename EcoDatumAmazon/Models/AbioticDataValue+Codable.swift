//
//  DataValue.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum AbioticDataValue: Codable {
  
  case DecimalDataValue(String)
  case AirOzoneScale(AirOzoneScale)
  case SoilPotassiumScale(SoilPotassiumScale)
  case SoilTextureScale(SoilTextureScale)
  case WaterOdorScale(WaterOdorScale)
  case WaterTurbidityScale(WaterTurbidityScale)
  
  enum CodingKeys: String, CodingKey {
    case abioticDataValue
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self = try container.decode(AbioticDataValue.self, forKey: .abioticDataValue)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self, forKey: .abioticDataValue)
  }
  
  static func ==(_ lhs: AbioticDataValue, _ rhs: AbioticDataValue) -> Bool {
    
    switch lhs {
    case .DecimalDataValue(let lhsDecimalDataValue):
      switch rhs {
      case .DecimalDataValue(let rhsDecimalDataValue):
        return Decimal(string: lhsDecimalDataValue) == Decimal(string: rhsDecimalDataValue)
      default: break
      }
    case .AirOzoneScale(let lhsAirOzoneScale):
      switch rhs {
      case .AirOzoneScale(let rhsAirOzoneScale):
        return lhsAirOzoneScale == rhsAirOzoneScale
      default: break
      }
    case .SoilPotassiumScale(let lhsSoilPotassiumScale):
      switch rhs {
      case .SoilPotassiumScale(let rhsSoilPotassiumScale):
        return lhsSoilPotassiumScale == rhsSoilPotassiumScale
      default: break
      }
    case .SoilTextureScale(let lhsSoilTextureScale):
      switch rhs {
      case .SoilTextureScale(let rhsSoilTextureScale):
        return lhsSoilTextureScale == rhsSoilTextureScale
      default: break
      }
    case .WaterOdorScale(let lhsWaterOdorScale):
      switch rhs {
      case .WaterOdorScale(let rhsWaterOdorScale):
        return lhsWaterOdorScale == rhsWaterOdorScale
      default: break
      }
    case .WaterTurbidityScale(let lhsWaterTurbidityScale):
      switch rhs {
      case .WaterTurbidityScale(let rhsWaterTurbidityScale):
        return lhsWaterTurbidityScale == rhsWaterTurbidityScale
      default: break
      }
    }
    
    return false
    
  }
  
}
