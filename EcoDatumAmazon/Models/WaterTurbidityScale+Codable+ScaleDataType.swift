//
//  WaterTurbidityScale.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum WaterTurbidityScale: Codable, ScaleDataType {
  
  case CrystalClear(index: Int, label: String)
  case SlightlyCloudy(index: Int, label: String)
  case ModeratelyCloudy(index: Int, label: String)
  case VeryCloudy(index: Int, label: String)
  case BlackishOrBrownish(index: Int, label: String)
  
  enum CodingKeys: String, CodingKey {
    case waterTurbidityScale
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self = try container.decode(WaterTurbidityScale.self, forKey: .waterTurbidityScale)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self, forKey: .waterTurbidityScale)
  }
  
  static func ==(_ lhs: WaterTurbidityScale, _ rhs: WaterTurbidityScale) -> Bool {
    
    var lhsIndex = 0
    switch lhs {
    case .CrystalClear(let index, _): lhsIndex = index
    case .SlightlyCloudy(let index, _): lhsIndex = index
    case .ModeratelyCloudy(let index, _): lhsIndex = index
    case .VeryCloudy(let index, _): lhsIndex = index
    case .BlackishOrBrownish(let index, _): lhsIndex = index
    }
    
    var rhsIndex = 0
    switch rhs {
    case .CrystalClear(let index, _): rhsIndex = index
    case .SlightlyCloudy(let index, _): rhsIndex = index
    case .ModeratelyCloudy(let index, _): rhsIndex = index
    case .VeryCloudy(let index, _): rhsIndex = index
    case .BlackishOrBrownish(let index, _): rhsIndex = index
    }
    
    return lhsIndex == rhsIndex
    
  }
  
  static let all: [WaterTurbidityScale] = [
    .CrystalClear(index: 0, label: "Crystal Clear"),
    .SlightlyCloudy(index: 1, label: "Slightly Cloudy"),
    .ModeratelyCloudy(index: 2, label: "Moderately Cloudy"),
    .VeryCloudy(index: 3, label: "Very Cloudy"),
    .BlackishOrBrownish(index: 4, label: "Blackish or Brownish")
  ]
  
}
