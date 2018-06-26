//
//  DateUtil.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/25/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

extension Date {
  
  func mediumFormattedDateString() -> String {
    return Formatter.mediumDateStyleFormatter.string(from: self)
  }
  
}
