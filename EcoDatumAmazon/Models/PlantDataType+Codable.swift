//
// Created by Kenneth Wingerden on 2019-01-06.
// Copyright (c) 2019 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum PlantDataType: String, Codable {

  case Algae
  case Conifer
  case Fern
  case Flower
  case Moss

  static let all: [PlantDataType] = [
    .Algae,
    .Conifer,
    .Fern,
    .Flower,
    .Moss
  ]

}
