//
//  FormatUtil.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/25/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

extension Formatter {
  
  static let iso8601DateFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
  }()
  
  static let mediumDateStyleFormatter: DateFormatter =  {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    return formatter
  }()
  
}
