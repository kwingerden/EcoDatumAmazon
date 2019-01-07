//
// Created by Kenneth Wingerden on 2019-01-06.
// Copyright (c) 2019 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum FungiDataType: String, Codable {

  case BreadMolds = "Bread Molds"
  case Mushrooms
  case WaterMolds = "Water Molds"
  case Yeast

  static let all: [FungiDataType] = [
    .BreadMolds,
    .Mushrooms,
    .WaterMolds,
    .Yeast
  ]

}
