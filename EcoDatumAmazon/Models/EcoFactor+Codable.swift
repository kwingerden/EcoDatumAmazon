//
//  AbioticOrBiotic.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum EcoFactor: Codable, CustomStringConvertible {
  
  case Abiotic(AbioticEcoData)
  case Biotic(BioticEcoData)
  
  var description: String {
    switch self {
    case .Abiotic:
      return "Abiotic"
    case .Biotic:
      return "Biotic"
    }
  }
  
  enum CodingKeys: String, CodingKey {
    case abioticFactor
    case bioticFactor
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    if container.contains(.abioticFactor) {
      let abioticEcoData = try container.decode(AbioticEcoData.self, forKey: .abioticFactor)
      self = EcoFactor.Abiotic(abioticEcoData)
    } else if container.contains(.abioticFactor) {
      let bioticEcoData = try container.decode(BioticEcoData.self, forKey: .bioticFactor)
      self = EcoFactor.Biotic(bioticEcoData)
    } else {
      fatalError()
    }
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    if let abioticEcoData = abioticEcoData {
      try container.encode(abioticEcoData, forKey: .abioticFactor)
    } else if let bioticEcoData = bioticEcoData {
      try container.encode(bioticEcoData, forKey: .bioticFactor)
    }
  }
  
  static let all: [EcoFactor] = [
    .Abiotic(AbioticEcoData()),
    .Biotic(BioticEcoData())
  ]
  
  var abioticEcoData: AbioticEcoData? {
    switch self {
    case .Abiotic(let abioticEcoData):
      return abioticEcoData
    default: return nil
    }
  }
  
  var bioticEcoData: BioticEcoData? {
    switch self {
    case .Biotic(let bioticEcoData):
      return bioticEcoData
    default: return nil
    }
  }
  
  func new(_ abioticEcoData: AbioticEcoData) -> EcoFactor {
    return EcoFactor.Abiotic(abioticEcoData)
  }
  
  func new(_ abioticFactor: AbioticFactor) -> EcoFactor {
    switch self {
    case .Abiotic(let abioticEcoData):
      return EcoFactor.Abiotic(abioticEcoData.new(abioticFactor))
    default: fatalError()
    }
  }
  
  func new(_ bioticEcoData: BioticEcoData) -> EcoFactor {
      return EcoFactor.Biotic(bioticEcoData)
  }
  
}
