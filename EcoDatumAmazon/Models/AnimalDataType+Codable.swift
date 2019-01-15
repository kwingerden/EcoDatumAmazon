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
    
    let invertebrateDataType = try container.decodeIfPresent(InvertebrateDataType.self, forKey: .animalDataType)
    if let invertebrateDataType = invertebrateDataType {
      self = .Invertebrate(invertebrateDataType)
    } else {
      let vertebrateDataType = try container.decodeIfPresent(VertebrateDataType.self, forKey: .animalDataType)
      if let vertebrateDataType = vertebrateDataType {
        self = .Vertebrate(vertebrateDataType)
      } else {
        fatalError()
      }
    }
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .Invertebrate(let dataType):
      try container.encode(dataType, forKey: .animalDataType)
    case .Vertebrate(let dataType):
      try container.encode(dataType, forKey: .animalDataType)
    }
  }
  
  static func ==(lhs: AnimalDataType, rhs: AnimalDataType) -> Bool {
    switch (lhs, rhs) {
    case let (.Vertebrate(v1), .Vertebrate(v2)) where v1 == v2: return true
    case let (.Invertebrate(v1), .Invertebrate(v2)) where v1 == v2: return true
    default: return false
    }
  }
  
}
