//
//  SoilPotassiumScale.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum SoilPotassiumScale: Codable, ScaleDataType {
  
  case Low(index: Int, label: String)
  case Medium(index: Int, label: String)
  case High(index: Int, label: String)
  
  enum CodingKeys: String, CodingKey {
    case soilPotassiumScale
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self = try container.decode(SoilPotassiumScale.self, forKey: .soilPotassiumScale)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self, forKey: .soilPotassiumScale)
  }
  
  static func ==(_ lhs: SoilPotassiumScale, _ rhs: SoilPotassiumScale) -> Bool {
    
    var lhsIndex = 0
    switch lhs {
    case .Low(let index, _): lhsIndex = index
    case .Medium(let index, _): lhsIndex = index
    case .High(let index, _): lhsIndex = index
    }
    
    var rhsIndex = 0
    switch rhs {
    case .Low(let index, _): rhsIndex = index
    case .Medium(let index, _): rhsIndex = index
    case .High(let index, _): rhsIndex = index
    }
    
    return lhsIndex == rhsIndex
    
  }
  
  static let all: [SoilPotassiumScale] = [
    .Low(index: 0, label: "Low"),
    .Medium(index: 1, label: "Medium"),
    .High(index: 2, label: "High")
  ]
  
}
