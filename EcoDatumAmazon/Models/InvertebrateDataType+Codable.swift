//
// Created by Kenneth Wingerden on 2019-01-06.
// Copyright (c) 2019 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum InvertebrateDataType: String, Codable {

  case Arthropod
  case Echinodermata
  case Jelly
  case Mollusca
  case Sponge
  case Worm

  static let all: [InvertebrateDataType] = [
    .Arthropod,
    .Echinodermata,
    .Jelly,
    .Mollusca,
    .Sponge,
    .Worm
  ]

}
