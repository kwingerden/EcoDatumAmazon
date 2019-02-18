//
//  SitePhoto+CoreData.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 2/17/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import CoreData
import Foundation
import UIKit

extension SitePhoto {
  
  static func create(site: Site? = nil,
                     date: Date? = nil,
                     photo: Data? = nil) throws -> SitePhoto {
    let entity = NSEntityDescription.entity(
      forEntityName: "SitePhoto",
      in: PersistenceUtil.shared.container.viewContext)!
    let sitePhoto = SitePhoto(entity: entity,
                              insertInto: PersistenceUtil.shared.container.viewContext)
    sitePhoto.site = site
    sitePhoto.date = date
    sitePhoto.photo = photo
    return sitePhoto
  }
  
  static func fetch() throws -> NSFetchedResultsController<SitePhoto> {
    let fetchRequest = SitePhoto.fetchRequest() as NSFetchRequest<SitePhoto>
    fetchRequest.sortDescriptors = [
      NSSortDescriptor(key: #keyPath(SitePhoto.date), ascending: true)
    ]
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: PersistenceUtil.shared.container.viewContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    try fetchedResultsController.performFetch()
    return fetchedResultsController
  }
  
  func save() throws {
    try PersistenceUtil.shared.saveContext()
  }
  
  func delete() throws {
    try PersistenceUtil.shared.delete(self)
  }
  
  func image() -> UIImage? {
    if let photo = photo {
      return UIImage(data: photo)
    } else {
      return nil
    }
  }
}
