//
//  FormatUtil.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/25/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

extension Formatter {
  
  static let mediumDateStyleFormatter: DateFormatter =  {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    return formatter
  }()
  
}
