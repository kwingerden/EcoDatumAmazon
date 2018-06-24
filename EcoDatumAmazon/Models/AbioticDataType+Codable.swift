//
//  AbioticDataTypeChoice.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum AbioticDataType: Codable {
  
  case Air(AirDataType)
  case Soil(SoilDataType)
  case Water(WaterDataType)
  
  enum CodingKeys: String, CodingKey {
    case abioticDataType
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self = try container.decode(AbioticDataType.self, forKey: .abioticDataType)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self, forKey: .abioticDataType)
  }
  
  static func ==(lhs: AbioticDataType, rhs: AbioticDataType) -> Bool {
    switch (lhs, rhs) {
    case let (.Air(v1), .Air(v2)) where v1 == v2: return true
    case let (.Soil(v1), .Soil(v2)) where v1 == v2: return true
    case let (.Water(v1), .Water(v2)) where v1 == v2: return true
    default: return false
    }
  }
  
}
