//
//  AirOzoneScale.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum AirOzoneScale: Codable {
  
  case LessThan90(index: Int, label: String)
  case Between90And150(index: Int, label: String)
  case GreaterThan150To210(index: Int, label: String)
  case GreaterThan210(index: Int, label: String)
  
  enum CodingKeys: String, CodingKey {
    case airOzoneScale
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self = try container.decode(AirOzoneScale.self, forKey: .airOzoneScale)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self, forKey: .airOzoneScale)
  }
  
  static func ==(_ lhs: AirOzoneScale, _ rhs: AirOzoneScale) -> Bool {
    
    var lhsIndex = 0
    switch lhs {
    case .LessThan90(let index, _): lhsIndex = index
    case .Between90And150(let index, _): lhsIndex = index
    case .GreaterThan150To210(let index, _): lhsIndex = index
    case .GreaterThan210(let index, _): lhsIndex = index
    }
    
    var rhsIndex = 0
    switch rhs {
    case .LessThan90(let index, _): rhsIndex = index
    case .Between90And150(let index, _): rhsIndex = index
    case .GreaterThan150To210(let index, _): rhsIndex = index
    case .GreaterThan210(let index, _): rhsIndex = index
    }
    
    return lhsIndex == rhsIndex
    
  }
  
  static let all: [AirOzoneScale] = [
    .LessThan90(index: 0, label: "<90"),
    .Between90And150(index: 1, label: "90-150"),
    .GreaterThan150To210(index: 2, label: ">150-210"),
    .GreaterThan210(index: 3, label: ">210")
  ]
  
}
