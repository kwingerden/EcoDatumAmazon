//
//  AbioticEcoData.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

struct AbioticEcoData: Codable, Equatable {
  
  let abioticFactor: AbioticFactor?
  let dataType: AbioticDataType?
  let dataUnit: DataUnit?
  let dataValue: DataValue?
  
  enum CodingKeys: String, CodingKey {
    case abioticFactor
    case dataType
    case dataUnit
    case dataValue
  }
  
  init(abioticFactor: AbioticFactor? = nil,
       dataType: AbioticDataType? = nil,
       dataUnit: DataUnit? = nil,
       dataValue: DataValue? = nil) {
    self.abioticFactor = abioticFactor
    self.dataType = dataType
    self.dataUnit = dataUnit
    self.dataValue = dataValue
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    abioticFactor = try container.decode(AbioticFactor.self, forKey: .abioticFactor)

    switch abioticFactor {
    case .Air?:
      dataType = AbioticDataType.Air(
        try container.decode(AirDataType.self, forKey: .dataType))
    case .Soil?:
      dataType = AbioticDataType.Soil(
        try container.decode(SoilDataType.self, forKey: .dataType))
    case .Water?:
      dataType = AbioticDataType.Water(
        try container.decode(WaterDataType.self, forKey: .dataType))
    default: fatalError()
    }
    
    dataUnit = try container.decode(DataUnit.self, forKey: .dataUnit)
    
    switch dataUnit {
      
    case ._Air_Ozone_Scale_?:
      var tempDataValue: DataValue?
      let dataValueString = try container.decode(String.self, forKey: .dataValue)
      AirOzoneScale.all.forEach {
        switch $0 {
        case .LessThan90(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.AirOzoneScale($0)
          }
        case .Between90And150(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.AirOzoneScale($0)
          }
        case .GreaterThan150To210(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.AirOzoneScale($0)
          }
        case .GreaterThan210(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.AirOzoneScale($0)
          }
        }
      }
      dataValue = tempDataValue
      
    case ._Soil_Potassium_Scale_?:
      var tempDataValue: DataValue?
      let dataValueString = try container.decode(String.self, forKey: .dataValue)
      SoilPotassiumScale.all.forEach {
        switch $0 {
        case .Low(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.SoilPotassiumScale($0)
          }
        case .Medium(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.SoilPotassiumScale($0)
          }
        case .High(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.SoilPotassiumScale($0)
          }
        }
      }
      dataValue = tempDataValue
      
    case ._Water_Odor_Scale_?:
      var tempDataValue: DataValue?
      let dataValueString = try container.decode(String.self, forKey: .dataValue)
      WaterOdorScale.all.forEach {
        switch $0 {
        case .NoOdor(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterOdorScale($0)
          }
        case .SlightOdor(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterOdorScale($0)
          }
        case .Smelly(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterOdorScale($0)
          }
        case .VerySmelly(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterOdorScale($0)
          }
        case .Devastating(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterOdorScale($0)
          }
        }
      }
      dataValue = tempDataValue
      
    case ._Water_Turbidity_Scale_?:
      var tempDataValue: DataValue?
      let dataValueString = try container.decode(String.self, forKey: .dataValue)
      WaterTurbidityScale.all.forEach {
        switch $0 {
        case .CrystalClear(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterTurbidityScale($0)
          }
        case .SlightlyCloudy(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterTurbidityScale($0)
          }
        case .ModeratelyCloudy(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterTurbidityScale($0)
          }
        case .VeryCloudy(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterTurbidityScale($0)
          }
        case .BlackishOrBrownish(_, let label):
          if dataValueString == label {
            tempDataValue = DataValue.WaterTurbidityScale($0)
          }
        }
      }
      dataValue = tempDataValue
      
    case ._Soil_Texture_Scale_?:
      dataValue = DataValue.SoilTextureScale(
        try container.decode(SoilTextureScale.self, forKey: .dataValue))
      
    default:
      dataValue = DataValue.DecimalDataValue(
        try container.decode(String.self, forKey: .dataValue))
      
    }
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(abioticFactor, forKey: .abioticFactor)
    
    switch dataType {
    case .Air(let airDataType)?:
      try container.encode(airDataType, forKey: .dataType)
    case .Soil(let soilDataType)?:
      try container.encode(soilDataType, forKey: .dataType)
    case .Water(let waterDataType)?:
      try container.encode(waterDataType, forKey: .dataType)
    default: fatalError()
    }
    
    try container.encode(dataUnit, forKey: .dataUnit)
    
    switch dataValue {
      
    case .DecimalDataValue(let decimalDataValue)?:
      try container.encode(decimalDataValue, forKey: .dataValue)
      
    case .AirOzoneScale(let airOzoneScale)?:
      switch airOzoneScale {
      case .LessThan90(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .Between90And150(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .GreaterThan150To210(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .GreaterThan210(_, let label):
        try container.encode(label, forKey: .dataValue)
      }
      
    case .SoilPotassiumScale(let soilPotassiumScale)?:
      switch soilPotassiumScale {
      case .Low(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .Medium(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .High(_, let label):
        try container.encode(label, forKey: .dataValue)
      }
      
    case .SoilTextureScale(let soilTextureScale)?:
      try container.encode(soilTextureScale, forKey: .dataValue)
      
    case .WaterOdorScale(let waterOdorScale)?:
      switch waterOdorScale {
      case .NoOdor(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .SlightOdor(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .Smelly(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .VerySmelly(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .Devastating(_, let label):
        try container.encode(label, forKey: .dataValue)
      }
      
    case .WaterTurbidityScale(let waterTurbidityScale)?:
      switch waterTurbidityScale {
      case .CrystalClear(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .SlightlyCloudy(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .ModeratelyCloudy(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .VeryCloudy(_, let label):
        try container.encode(label, forKey: .dataValue)
      case .BlackishOrBrownish(_, let label):
        try container.encode(label, forKey: .dataValue)
      }
      
    default: fatalError()
      
    }
    
  }
  
  func new(_ abioticFactor: AbioticFactor) -> AbioticEcoData {
    return AbioticEcoData(
      abioticFactor: abioticFactor,
      dataType: dataType,
      dataUnit: dataUnit,
      dataValue: dataValue)
  }

  func new(_ dataType: AbioticDataType) -> AbioticEcoData {
    return AbioticEcoData(
      abioticFactor: abioticFactor,
      dataType: dataType,
      dataUnit: dataUnit,
      dataValue: dataValue)
  }
  
  func new(_ dataUnit: DataUnit) -> AbioticEcoData {
    return AbioticEcoData(
      abioticFactor: abioticFactor,
      dataType: dataType,
      dataUnit: dataUnit,
      dataValue: dataValue)
  }
  
  func new(_ dataValue: DataValue?) -> AbioticEcoData {
    return AbioticEcoData(
      abioticFactor: abioticFactor,
      dataType: dataType,
      dataUnit: dataUnit,
      dataValue: dataValue)
  }
  
  static func ==(lhs: AbioticEcoData, rhs: AbioticEcoData) -> Bool {
    return lhs.abioticFactor == rhs.abioticFactor &&
      lhs.dataType == rhs.dataType &&
      lhs.dataUnit == rhs.dataUnit &&
      lhs.dataValue == rhs.dataValue
  }
  
}
