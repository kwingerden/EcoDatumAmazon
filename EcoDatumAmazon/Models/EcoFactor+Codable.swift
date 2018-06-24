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
    case ecoFactor
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self = try container.decode(EcoFactor.self, forKey: .ecoFactor)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self, forKey: .ecoFactor)
  }
  
  static let all: [EcoFactor] = [
    .Abiotic(AbioticEcoData()),
    .Biotic(BioticEcoData())
  ]
  
}
