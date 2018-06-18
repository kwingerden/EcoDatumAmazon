//
//  Site.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/15/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import CoreData
import Foundation

let SITE_NAME_PLACEHOLDER = "<Site Name>"

extension Site {
  
  static func new(name: String? = SITE_NAME_PLACEHOLDER,
                  notes: NSAttributedString? = nil,
                  latitude: NSDecimalNumber? = 0.0,
                  longitude: NSDecimalNumber? = 0.0,
                  coordinateAccuracy: NSDecimalNumber? = 0.0,
                  altitude: NSDecimalNumber? = 0.0,
                  altitudeAccuracy: NSDecimalNumber? = 0.0,
                  photo: Data? = nil) throws -> Site {
    let entity = NSEntityDescription.entity(
      forEntityName: "Site",
      in: PersistenceUtil.shared.container.viewContext)!
    let site = Site(
      entity: entity,
      insertInto: PersistenceUtil.shared.container.viewContext)
    site.id = UUID()
    site.name = name
    site.notes = notes
    site.latitude = latitude
    site.longitude = longitude
    site.coordinateAccuracy = coordinateAccuracy
    site.altitude = altitude
    site.altitudeAccuracy = altitudeAccuracy
    site.photo = photo
    site.ecoData = []
    return site
  }
  
  static func fetch() throws -> NSFetchedResultsController<Site> {
    let fetchRequest = Site.fetchRequest() as NSFetchRequest<Site>
    fetchRequest.sortDescriptors = [
      NSSortDescriptor(key: #keyPath(Site.name), ascending: true)
    ]
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: PersistenceUtil.shared.container.viewContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    try fetchedResultsController.performFetch()
    return fetchedResultsController
  }
  
  func save() throws -> Site {
    try PersistenceUtil.shared.saveContext()
    return self
  }
  
  func delete() throws {
    try PersistenceUtil.shared.delete(self)
  }
  
}
