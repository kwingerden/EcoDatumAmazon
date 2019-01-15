//
// Created by Kenneth Wingerden on 2019-01-06.
// Copyright (c) 2019 Kenneth Wingerden. All rights reserved.
//

import Foundation

enum AnimalFactor: String, Codable {

  case Invertebrate
  case Vertebrate

  static let all: [AnimalFactor] = [
    .Invertebrate,
    .Vertebrate
  ]

}