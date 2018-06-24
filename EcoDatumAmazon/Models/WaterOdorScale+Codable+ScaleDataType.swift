//
//  WaterOdorScale.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum WaterOdorScale: Codable, ScaleDataType {
  
  case NoOdor(index: Int, label: String)
  case SlightOdor(index: Int, label: String)
  case Smelly(index: Int, label: String)
  case VerySmelly(index: Int, label: String)
  case Devastating(index: Int, label: String)
  
  enum CodingKeys: String, CodingKey {
    case waterOdorScale
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self = try container.decode(WaterOdorScale.self, forKey: .waterOdorScale)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self, forKey: .waterOdorScale)
  }
  
  static func ==(_ lhs: WaterOdorScale, _ rhs: WaterOdorScale) -> Bool {
    
    var lhsIndex = 0
    switch lhs {
    case .NoOdor(let index, _): lhsIndex = index
    case .SlightOdor(let index, _): lhsIndex = index
    case .Smelly(let index, _): lhsIndex = index
    case .VerySmelly(let index, _): lhsIndex = index
    case .Devastating(let index, _): lhsIndex = index
    }
    
    var rhsIndex = 0
    switch rhs {
    case .NoOdor(let index, _): rhsIndex = index
    case .SlightOdor(let index, _): rhsIndex = index
    case .Smelly(let index, _): rhsIndex = index
    case .VerySmelly(let index, _): rhsIndex = index
    case .Devastating(let index, _): rhsIndex = index
    }
    
    return lhsIndex == rhsIndex
    
  }
  
  static let all: [WaterOdorScale] = [
    .NoOdor(index: 0, label: "No Odor"),
    .SlightOdor(index: 1, label: "Slight Odor"),
    .Smelly(index: 2, label: "Smelly"),
    .VerySmelly(index: 3, label: "Very Smelly"),
    .Devastating(index: 4, label: "Devastating")
  ]
  
}
