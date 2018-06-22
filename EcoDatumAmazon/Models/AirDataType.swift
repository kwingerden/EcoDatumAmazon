//
//  AirDataType.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum AirDataType: String, Codable {
  
  case Velocity
  case CarbonDioxide = "Carbon Dioxide"
  case Light
  case PAR
  case RelativeHumidity = "Relative Humidity"
  case Temperature
  case UVB
  case Ozone
  
  static let all: [AirDataType] = [
    .CarbonDioxide,
    .Light,
    .Ozone,
    .PAR,
    .RelativeHumidity,
    .Temperature,
    .UVB,
    .Velocity
  ]
  
}
