//
//  SitePhoto+Codable.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 2/18/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

struct SitePhotoCodable: Codable {

  let date: Date?
  let photo: UIImage?
  
  enum CodingKeys: String, CodingKey {
    case date
    case photo
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
  }
}
