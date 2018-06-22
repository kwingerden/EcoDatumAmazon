//
//  AbioticOrBiotic.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum EcoFactor: Codable {
  
  case Abiotic(AbioticEcoData)
  case Biotic(BioticEcoData)
  
  enum CodingKeys: String, CodingKey {
    case abiotic
    case biotic
  }
  
  init(from decoder: Decoder) throws {
    self = .Abiotic(AbioticEcoData())
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .Abiotic(let abioticEcoData):
      try container.encode(abioticEcoData, forKey: .abiotic)
    case .Biotic(let bioticEcoData):
      try container.encode(bioticEcoData, forKey: .biotic)
    }
  }
  
  static let all: [EcoFactor] = [
    .Abiotic(AbioticEcoData()),
    .Biotic(BioticEcoData())
  ]
  
}
