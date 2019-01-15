//
//  AnimalData.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 1/14/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import Foundation

struct AnimalData: Codable {
  
  let animalFactor: AnimalFactor?
  let animalDataType: AnimalDataType?
  
  enum CodingKeys: String, CodingKey {
    case animalFactor
    case animalDataType
  }
  
  init(animalFactor: AnimalFactor? = nil,
       animalDataType: AnimalDataType? = nil) {
    self.animalFactor = animalFactor
    self.animalDataType = animalDataType
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    animalFactor = try container.decode(AnimalFactor.self, forKey: .animalFactor)
    animalDataType = try container.decode(AnimalDataType.self, forKey: .animalDataType)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(animalFactor, forKey: .animalFactor)
    try container.encode(animalDataType, forKey: .animalDataType)
  }
  
  static func ==(lhs: AnimalData, rhs: AnimalData) -> Bool {
    switch lhs.animalFactor {
    case .Invertebrate?:
      if AnimalFactor.Invertebrate != rhs.animalFactor {
        return false
      }
    case .Vertebrate?:
      if AnimalFactor.Vertebrate != rhs.animalFactor {
        return false
      }
    default:
      if rhs.animalFactor != nil {
        return false
      }
    }
    
    switch lhs.animalDataType {
    case .Invertebrate(let lhsInvertebrateDataType)?:
      switch rhs.animalDataType {
      case .Invertebrate(let rhsInvertebrateDataType)?:
        return lhsInvertebrateDataType == rhsInvertebrateDataType
      default:
        return false
      }
    case .Vertebrate(let lhsVertebrateDataType)?:
      switch rhs.animalDataType {
      case .Vertebrate(let rhsVertebrateDataType)?:
        return lhsVertebrateDataType == rhsVertebrateDataType
      default:
        return false
      }
    
    default:
      return false
      
    }
  }
  
}
