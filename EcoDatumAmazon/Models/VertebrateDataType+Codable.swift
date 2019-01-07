//
// Created by Kenneth Wingerden on 2019-01-06.
// Copyright (c) 2019 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum VertebrateDataType: String, Codable {

  case Amphibian
  case Bird
  case Fish
  case Mammal
  case Reptile

  static let all: [VertebrateDataType] = [
    .Amphibian,
    .Bird,
    .Fish,
    .Mammal,
    .Reptile
  ]

}
