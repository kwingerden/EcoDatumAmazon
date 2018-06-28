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
  
  let bioticFactor: BioticFactor?
  let image: UIImage?
  let notes: NSAttributedString?
  
  init(bioticFactor: BioticFactor? = nil,
       image: UIImage? = nil,
       notes: NSAttributedString? = nil) {
    self.bioticFactor = bioticFactor
    self.image = image
    self.notes = notes
  }
  
  enum CodingKeys: String, CodingKey {
    case bioticFactor
    case image
    case notes
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    bioticFactor = try container.decodeIfPresent(BioticFactor.self, forKey: .bioticFactor)
    
    if let imageBase64Encoded = try container.decodeIfPresent(Base64Encoded.self, forKey: .image) {
      image = UIImage.base64Decode(imageBase64Encoded)
    } else {
      image = nil
    }
    
    if let notesBase64Encoded = try container.decodeIfPresent(Base64Encoded.self, forKey: .notes) {
      notes = try NSAttributedString.base64Decode(notesBase64Encoded)
    } else {
      notes = nil
    }
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(bioticFactor, forKey: .bioticFactor)
    try container.encodeIfPresent(image?.base64Encode(), forKey: .image)
    try container.encodeIfPresent(notes?.base64Encode(), forKey: .notes)
  }
  
  func new(_ bioticFactor: BioticFactor?) -> BioticEcoData {
    return BioticEcoData(
      bioticFactor: bioticFactor,
      image: image,
      notes: notes)
  }
  
  func new(_ image: UIImage?) -> BioticEcoData {
    return BioticEcoData(
      bioticFactor: bioticFactor,
      image: image,
      notes: notes)
  }
  
  func new(_ notes: NSAttributedString) -> BioticEcoData {
    return BioticEcoData(
      bioticFactor: bioticFactor,
      image: image,
      notes: notes)
  }
  
}
