//
//  AbioticDataUnitChoice.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum AbioticDataUnit: String, Codable {
  
  // Latex Editor: http://www.hostmath.com
  
  case PartsPerMillion = "ppm \\ (Parts \\ Per \\ Million)"
  case Lux = "Lux"
  case PhotosyntheticPhotonFluxDensity = "PPFD \\ (Photosynthetic \\ Photon \\ Flux \\ Density)"
  case MicromolesPerMetersSquaredAndSeconds = "\\mu mol \\ m^{-2}s^{-1}"
  case Percent = "\\%"
  case DegreesCelsius = "^{\\circ}C"
  case DegreesFahrenheit = "^{\\circ}F"
  case MegawattsPerMeterSquared = "\\frac{mW}{m^{2}}"
  case MetersPerSecond = "\\frac{m}{s}"
  case MilesPerHour = "mph"
  case PoundsPerAcre = "\\frac{lb}{a}"
  case MicrosiemensPerCentimeter = "\\frac{\\mu S}{cm}"
  case FeetPerSecond = "\\frac{ft}{s}"
  case MilligramsPerLiter = "\\frac{mg}{L}"
  case NephelometricTurbidityUnits = "NTU \\ (Nephelometric \\ Turbidity \\ Units)"
  case JacksonTurbidityUnits = "JTU \\ (Jackson \\ Turbidity \\ Units)"
  
  case _Air_Ozone_Scale_ = "Air \\ Ozone \\ Scale \\ (\\frac{\\mu g}{m^{3}O_{3}})"
  case _Soil_Potassium_Scale_ = "Soil \\ Potassium \\ Scale"
  case _Soil_Texture_Scale_ = "Soil \\ Texture \\ Scale"
  case _Water_Odor_Scale_ = "Water \\ Odor \\ Scale"
  case _Water_pH_Scale_ = "Water \\ pH \\ Scale"
  case _Water_Turbidity_Scale_ = "Water \\ Turbidity \\ Scale"
  
  static func units(_ dataType: AbioticDataType) -> [AbioticDataUnit] {
    
    switch dataType {
      
      // ** AIR
      
    case .Air(let airDataType) where airDataType == .CarbonDioxide:
      return [
        .PartsPerMillion
      ]
      
    case .Air(let airDataType) where airDataType == .Light:
      return [
        .Lux
      ]
      
    case .Air(let airDataType) where airDataType == .PAR:
      return [
        .PhotosyntheticPhotonFluxDensity,
        .MicromolesPerMetersSquaredAndSeconds
      ]
      
    case .Air(let airDataType) where airDataType == .RelativeHumidity:
      return [
        .Percent
      ]
      
    case .Air(let airDataType) where airDataType == .Temperature:
      return [
        .DegreesCelsius,
        .DegreesFahrenheit
      ]
      
    case .Air(let airDataType) where airDataType == .UVB:
      return [
        .MegawattsPerMeterSquared,
        .Percent
      ]
      
    case .Air(let airDataType) where airDataType == .Velocity:
      return [
        .MetersPerSecond,
        .MilesPerHour
      ]
      
    case .Air(let airDataType) where airDataType == .Ozone:
      return [
        ._Air_Ozone_Scale_
      ]
      
      // ** SOIL
      
    case .Soil(let soilDataType)
      where soilDataType == .Nitrogen || soilDataType == .Phosphorus:
      return [
        .PoundsPerAcre
      ]
      
    case .Soil(let soilDataType) where soilDataType == .Potassium:
      return [
        ._Soil_Potassium_Scale_
      ]
      
    case .Soil(let soilDataType) where soilDataType == .Moisture:
      return [
        .Percent
      ]
      
    case .Soil(let soilDataType) where soilDataType == .Texture:
      return [
        ._Soil_Texture_Scale_
      ]
      
    case .Soil(let soilDataType) where soilDataType == .Temperature:
      return [
        .DegreesCelsius,
        .DegreesFahrenheit
      ]
      
      // ** WATER
      
    case .Water(let waterDataType) where waterDataType == .Conductivity:
      return [
        .MicrosiemensPerCentimeter
      ]
      
    case .Water(let waterDataType) where waterDataType == .DissolvedOxygen:
      return [
        .PartsPerMillion,
        .MilligramsPerLiter,
        .Percent
      ]
      
    case .Water(let waterDataType) where waterDataType == .FlowRate:
      return [
        .MetersPerSecond,
        .FeetPerSecond
      ]
      
    case .Water(let waterDataType) where waterDataType == .Nitrate:
      return [
        .PartsPerMillion,
        .MilligramsPerLiter
      ]
      
    case .Water(let waterDataType) where waterDataType == .Odor:
      return [
        ._Water_Odor_Scale_
      ]
      
    case .Water(let waterDataType) where waterDataType == .PAR:
      return [
        .PhotosyntheticPhotonFluxDensity,
        .MicromolesPerMetersSquaredAndSeconds
      ]
      
    case .Water(let waterDataType) where waterDataType == .pH:
      return [
        ._Water_pH_Scale_
      ]
      
    case .Water(let waterDataType) where waterDataType == .Phosphate:
      return [
        .PartsPerMillion,
        .MilligramsPerLiter
      ]
      
    case .Water(let waterDataType) where waterDataType == .Temperature:
      return [
        .DegreesCelsius,
        .DegreesFahrenheit
      ]
      
    case .Water(let waterDataType) where waterDataType == .Turbidity:
      return [
        .NephelometricTurbidityUnits,
        .JacksonTurbidityUnits,
        ._Water_Turbidity_Scale_
      ]
      
    default: return []
      
    }
    
  }
  
}
