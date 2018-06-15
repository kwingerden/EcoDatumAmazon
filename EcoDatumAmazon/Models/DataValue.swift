//
//  DataValue.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum DataValue {
  
  case DecimalDataValue(DecimalDataValue)
  case AirOzoneScale(AirOzoneScale)
  case SoilPotassiumScale(SoilPotassiumScale)
  case SoilTextureScale(SoilTextureScale)
  case WaterOdorScale(WaterOdorScale)
  case WaterTurbidityScale(WaterTurbidityScale)
  
  static func ==(_ lhs: DataValue, _ rhs: DataValue) -> Bool {
    
    switch lhs {
    case .DecimalDataValue(let lhsDecimalDataValue):
      switch rhs {
      case .DecimalDataValue(let rhsDecimalDataValue):
        return lhsDecimalDataValue == rhsDecimalDataValue
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
