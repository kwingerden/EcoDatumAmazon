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
  
  static let selectedSiteKeyPath = "selectedSite"
  dynamic var selectedSite: Site?
  
  static let isNewSiteKeyPath = "isNewSite"
  dynamic var isNewSite: NSObject?
  
  static let refreshSiteTableKeyPath = "refreshSiteTable"
  dynamic var refreshSiteTable: NSObject?
  
  var selectedTabIndex: Int = 0
  
}
