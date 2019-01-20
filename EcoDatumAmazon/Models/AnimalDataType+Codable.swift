//
// Created by Kenneth Wingerden on 2019-01-06.
// Copyright (c) 2019 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum AnimalDataType: Codable {

  case Invertebrate(InvertebrateDataType)
  case Vertebrate(VertebrateDataType)

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    
    let invertebrateDataType = try? container.decode(InvertebrateDataType.self)
    if let invertebrateDataType = invertebrateDataType {
      self = .Invertebrate(invertebrateDataType)
    } else {
      let vertebrateDataType = try? container.decode(VertebrateDataType.self)
      if let vertebrateDataType = vertebrateDataType {
        self = .Vertebrate(vertebrateDataType)
      } else {
        fatalError()
      }
    }
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .Invertebrate(let dataType):
      try container.encode(dataType)
    case .Vertebrate(let dataType):
      try container.encode(dataType)
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
