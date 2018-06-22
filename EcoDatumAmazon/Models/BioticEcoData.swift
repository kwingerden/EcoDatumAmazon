//
//  BioticEcoData.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

struct BioticEcoData: Codable {
  
  let image: UIImage?
  let notes: NSAttributedString?
  
  init(image: UIImage? = nil,
       notes: NSAttributedString? = nil) {
    self.image = image
    self.notes = notes
  }
  
  enum CodingKeys: String, CodingKey {
    case image
    case notes
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    image = UIImage.base64Decode(
      try container.decode(Base64Encoded.self, forKey: .image))
    notes = try NSAttributedString.base64Decode(
      try container.decode(Base64Encoded.self, forKey: .notes))
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(image!.base64Encode(), forKey: .image)
    try container.encode(notes!.base64Encode(), forKey: .notes)
  }
  
  func new(image: UIImage?) -> BioticEcoData {
    return BioticEcoData(
      image: image,
      notes: nil)
  }
  
  func new(notes: NSAttributedString) -> BioticEcoData {
    return BioticEcoData(
      image: image,
      notes: notes)
  }
  
}
