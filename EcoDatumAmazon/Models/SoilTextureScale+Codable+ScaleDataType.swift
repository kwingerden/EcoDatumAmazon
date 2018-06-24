//
//  SoilTextureScale.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

struct SoilTextureScale: Codable, ScaleDataType {
  
  let percentSand: Int
  let percentSilt: Int
  let percentClay: Int
  
  init(percentSand: Int,
       percentSilt: Int,
       percentClay: Int) {
    self.percentSand = percentSand
    self.percentSilt = percentSilt
    self.percentClay = percentClay
  }
  
  static func ==(_ lhs: SoilTextureScale, _ rhs: SoilTextureScale) -> Bool {
    return lhs.percentSand == rhs.percentSand &&
      lhs.percentSilt == rhs.percentSilt &&
      lhs.percentClay == rhs.percentClay
  }
  
}
