//
//  ViewContext.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/15/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

@objcMembers class ViewContext: NSObject {
  
  static let shared: ViewContext = ViewContext()
  
  dynamic var selectedSite: Site?
    
}
