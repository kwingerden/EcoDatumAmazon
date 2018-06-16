//
//  Site.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/15/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import CoreData
import Foundation

extension Site {
  
  static func newSite(name: String? = nil,
                      latitude: NSDecimalNumber? = 0.0,
                      longitude: NSDecimalNumber? = 0.0) -> Site {
    let entity = NSEntityDescription.entity(
      forEntityName: "Site",
      in: PersistenceUtil.shared.container.viewContext)!
    let site = Site(
      entity: entity,
      insertInto: PersistenceUtil.shared.container.viewContext)
    site.id = UUID()
    site.name = name
    site.latitude = latitude
    site.longitude = longitude
    return site
  }
  
}
