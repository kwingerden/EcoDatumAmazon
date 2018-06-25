//
//  AbioticOrBiotic.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

typealias CollectionDate = Date

struct EcoFactor: Codable, CustomStringConvertible {

  enum EcoData {
    case Abiotic(AbioticEcoData)
    case Biotic(BioticEcoData)
  
    static let all: [EcoData] = [
      .Abiotic(AbioticEcoData()),
      .Biotic(BioticEcoData())
    ]
  }
  
  var collectionDate: CollectionDate?
  
  var ecoData: EcoData?
  
  var description: String {
    switch ecoData {
    case .Abiotic?:
      return "Abiotic"
    case .Biotic?:
      return "Biotic"
    default:
      return "UNKNOWN"
    }
  }
  
  enum CodingKeys: String, CodingKey {
    case collectionDate
    case abioticFactor
    case bioticFactor
  }
  
  init(collectionDate: CollectionDate? = nil,
       ecoData: EcoData? = nil) {
    self.collectionDate = collectionDate
    self.ecoData = ecoData
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    collectionDate = try container.decode(CollectionDate.self, forKey: .collectionDate)
    if container.contains(.abioticFactor) {
      let abioticEcoData = try container.decode(AbioticEcoData.self, forKey: .abioticFactor)
      ecoData = EcoData.Abiotic(abioticEcoData)
    } else if container.contains(.abioticFactor) {
      let bioticEcoData = try container.decode(BioticEcoData.self, forKey: .bioticFactor)
      ecoData = EcoData.Biotic(bioticEcoData)
    } else {
      fatalError()
    }
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(collectionDate, forKey: .collectionDate)
    if let abioticEcoData = abioticEcoData {
      try container.encode(abioticEcoData, forKey: .abioticFactor)
    } else if let bioticEcoData = bioticEcoData {
      try container.encode(bioticEcoData, forKey: .bioticFactor)
    }
  }
  
  var abioticEcoData: AbioticEcoData? {
    get {
      switch ecoData {
      case .Abiotic(let abioticEcoData)?:
        return abioticEcoData
      default: return nil
      }
    }
    set {
      if let abioticEcoData = newValue {
        ecoData = .Abiotic(abioticEcoData)
      } else {
        LOG.error("Error setting abioticEcoData variable")
      }
    }
  }
  
  var bioticEcoData: BioticEcoData? {
    get {
      switch ecoData {
      case .Biotic(let bioticEcoData)?:
        return bioticEcoData
      default: return nil
      }
    }
    set {
      if let bioticEcoData = newValue {
        ecoData = .Biotic(bioticEcoData)
      } else {
        LOG.error("Error setting bioticEcoData variable")
      }
    }
  }
  
}
