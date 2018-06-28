//
//  AbioticFactor.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum BioticFactor: String, Codable {
  
  case Animal
  case Fungi
  case Plant
  
  static let all: [BioticFactor] = [
    .Animal,
    .Fungi,
    .Plant
  ]
  
}
