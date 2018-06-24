//
//  AbioticDataType.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum BioticDataType: String, Codable {
  
  case Animal
  case Fungi
  case Plant
  
  static let all: [BioticDataType] = [
    .Animal,
    .Fungi,
    .Plant
  ]
  
}
