//
//  BioticDataType+Codable.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 1/6/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum BioticDataType: Codable {

  case Animal(AnimalDataType)
  case Fungi(FungiDataType)
  case Plant(PlantDataType)

  enum CodingKeys: String, CodingKey {
    case bioticDataType
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self = try container.decode(BioticDataType.self, forKey: .bioticDataType)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self, forKey: .bioticDataType)
  }
  
  static func ==(lhs: BioticDataType, rhs: BioticDataType) -> Bool {
    switch (lhs, rhs) {
    case let (.Animal(v1), .Animal(v2)) where v1 == v2: return true
    case let (.Fungi(v1), .Fungi(v2)) where v1 == v2: return true
    case let (.Plant(v1), .Plant(v2)) where v1 == v2: return true
    default: return false
    }
  }

}
