//
// Created by Kenneth Wingerden on 2019-01-06.
// Copyright (c) 2019 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum AnimalDataType: Codable {

  case Invertebrate(InvertebrateDataType)
  case Vertebrate(VertebrateDataType)

  enum CodingKeys: String, CodingKey {
    case animalDataType
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self = try container.decode(AnimalDataType.self, forKey: .animalDataType)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self, forKey: .animalDataType)
  }
  
  static func ==(lhs: AnimalDataType, rhs: AnimalDataType) -> Bool {
    switch (lhs, rhs) {
    case let (.Vertebrate(v1), .Vertebrate(v2)) where v1 == v2: return true
    case let (.Invertebrate(v1), .Invertebrate(v2)) where v1 == v2: return true
    default: return false
    }
  }
  
}
