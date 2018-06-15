//
//  AbioticFactor.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum AbioticFactor: String {
  
  case Air
  case Soil
  case Water
  
  static let all: [AbioticFactor] = [
    .Air,
    .Soil,
    .Water
  ]
  
}
